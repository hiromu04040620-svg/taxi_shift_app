#!/usr/bin/env ruby

require "json"
require "jwt"
require "net/http"
require "openssl"
require "optparse"
require "time"
require "uri"

module TaxiShift
  module AppStoreConnect
    APP_ID = "6779931758"
    IAP_ID = "6779932155"
    IAP_PRODUCT_ID = "remove_ads"
    IAP_LOCALIZATION_ID = "b284a866-679b-4cd5-ac87-4e0649450228"

    class ApiError < StandardError; end

    class Client
      API_ORIGIN = "https://api.appstoreconnect.apple.com"

      def initialize(key_id:, issuer_id:, key_path:)
        @key_id = key_id
        @issuer_id = issuer_id
        @private_key = OpenSSL::PKey::EC.new(File.read(key_path))
      end

      def get(path, optional: false)
        request_json(Net::HTTP::Get, path, optional: optional)
      end

      def patch(path, body:)
        request_json(Net::HTTP::Patch, path, body: body)
      end

      private

      def request_json(request_class, path, body: nil, optional: false)
        uri = URI("#{API_ORIGIN}#{path}")
        request = request_class.new(uri)
        request["Authorization"] = "Bearer #{token}"
        if body
          request["Content-Type"] = "application/json"
          request.body = JSON.generate(body)
        end

        response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          http.open_timeout = 20
          http.read_timeout = 60
          http.request(request)
        end

        return nil if optional && response.code.to_i == 404

        parsed = JSON.parse(response.body)
        return parsed if response.code.to_i.between?(200, 299)

        details = Array(parsed["errors"]).filter_map do |error|
          error["detail"] || error["title"]
        end.join(" / ")
        raise ApiError, "#{request.method} #{uri.path} failed (#{response.code}): #{details}"
      end

      def token
        now = Time.now.to_i
        return @token if @token && now < @token_expires_at

        @token_expires_at = now + 900
        @token = JWT.encode(
          {
            iss: @issuer_id,
            iat: now,
            exp: @token_expires_at,
            aud: "appstoreconnect-v1",
          },
          @private_key,
          "ES256",
          { kid: @key_id, typ: "JWT" },
        )
      end
    end

    class IapLocalizationUpdater
      def initialize(client:, localization_id: IAP_LOCALIZATION_ID)
        @client = client
        @localization_id = localization_id
      end

      def update(name:, description:)
        @client.patch(
          "/v1/inAppPurchaseLocalizations/#{@localization_id}",
          body: {
            data: {
              type: "inAppPurchaseLocalizations",
              id: @localization_id,
              attributes: {
                name: name,
                description: description,
              },
            },
          },
        )
      end
    end

    class Audit
      EDITABLE_VERSION_STATES = %w[
        DEVELOPER_REJECTED
        METADATA_REJECTED
        PREPARE_FOR_SUBMISSION
        READY_FOR_REVIEW
        REJECTED
      ].freeze

      def initialize(client:, app_id: APP_ID, iap_id: IAP_ID, repo_root: nil)
        @client = client
        @app_id = app_id
        @iap_id = iap_id
        @repo_root = repo_root || File.expand_path("..", __dir__)
      end

      def snapshot
        versions_payload = @client.get(
          "/v1/apps/#{@app_id}/appStoreVersions?#{query(filter: { platform: "IOS" }, include: "build", limit: 50)}",
        )
        version_data = select_version(Array(versions_payload["data"]))
        raise ApiError, "提出対象のiOS App Storeバージョンが見つかりません" unless version_data

        included_builds = Array(versions_payload["included"]).select do |item|
          item["type"] == "builds"
        end.to_h { |item| [item["id"], item] }
        selected_build_id = version_data.dig("relationships", "build", "data", "id")
        selected_build = included_builds[selected_build_id]
        if selected_build_id && selected_build.nil?
          selected_build = @client.get("/v1/builds/#{selected_build_id}")["data"]
        end

        iap_payload = @client.get("/v2/inAppPurchases/#{@iap_id}")
        localization_payload = @client.get(
          "/v2/inAppPurchases/#{@iap_id}/inAppPurchaseLocalizations?#{query(limit: 50)}",
        )
        availability_payload = @client.get(
          "/v2/inAppPurchases/#{@iap_id}/inAppPurchaseAvailability?#{query(include: "availableTerritories", limit: { availableTerritories: 50 })}",
          optional: true,
        )
        price_payload = @client.get(
          "/v2/inAppPurchases/#{@iap_id}/iapPriceSchedule?#{query(include: "baseTerritory,manualPrices", limit: { manualPrices: 50 })}",
          optional: true,
        )
        screenshot_payload = @client.get(
          "/v2/inAppPurchases/#{@iap_id}/appStoreReviewScreenshot",
          optional: true,
        )

        review_detail_payload = @client.get(
          "/v1/appStoreVersions/#{version_data.fetch("id")}/appStoreReviewDetail",
          optional: true,
        )
        review_detail = review_detail_payload&.dig("data")
        attachments_payload = if review_detail
                                @client.get(
                                  "/v1/appStoreReviewDetails/#{review_detail.fetch("id")}/appStoreReviewAttachments?#{query(limit: 50)}",
                                )
                              end

        builds_payload = @client.get(
          "/v1/builds?#{query(filter: { app: @app_id }, include: "preReleaseVersion", sort: "-uploadedDate", limit: 10)}",
        )
        submissions_payload = @client.get(
          "/v1/apps/#{@app_id}/reviewSubmissions?#{query(include: "items", limit: 10)}",
          optional: true,
        )

        {
          generated_at: Time.now.utc.iso8601,
          expected_build_number: expected_build_number,
          app: { id: @app_id },
          version: version_summary(version_data, selected_build),
          latest_builds: Array(builds_payload["data"]).map { |build| build_summary(build) },
          iap: iap_summary(
            iap_payload,
            localization_payload,
            availability_payload,
            price_payload,
            screenshot_payload,
          ),
          review: review_summary(review_detail, attachments_payload),
          submissions: Array(submissions_payload&.dig("data")).map do |submission|
            {
              id: submission["id"],
              state: submission.dig("attributes", "state"),
              submitted_date: submission.dig("attributes", "submittedDate"),
            }
          end,
        }
      end

      private

      def select_version(versions)
        requested_id = ENV["ASC_APP_VERSION_ID"]
        return versions.find { |version| version["id"] == requested_id } if requested_id

        requested_version = ENV["ASC_APP_VERSION"]
        candidates = versions.select do |version|
          state = version.dig("attributes", "appVersionState")
          version_string = version.dig("attributes", "versionString")
          EDITABLE_VERSION_STATES.include?(state) &&
            (requested_version.nil? || requested_version == version_string)
        end
        candidates.max_by { |version| version.dig("attributes", "createdDate").to_s }
      end

      def expected_build_number
        pubspec = File.read(File.join(@repo_root, "pubspec.yaml"))
        pubspec[/^version:\s*\d+\.\d+\.\d+\+(\d+)$/, 1]
      end

      def version_summary(version, selected_build)
        {
          id: version["id"],
          version_string: version.dig("attributes", "versionString"),
          state: version.dig("attributes", "appVersionState"),
          selected_build: selected_build && build_summary(selected_build),
        }
      end

      def build_summary(build)
        {
          id: build["id"],
          number: build.dig("attributes", "version"),
          processing_state: build.dig("attributes", "processingState"),
          uploaded_date: build.dig("attributes", "uploadedDate"),
        }
      end

      def iap_summary(iap_payload, localizations, availability, price, screenshot)
        iap = iap_payload.fetch("data")
        availability_data = availability&.dig("data")
        price_data = price&.dig("data")
        screenshot_data = screenshot&.dig("data")

        {
          id: iap["id"],
          product_id: iap.dig("attributes", "productId"),
          state: iap.dig("attributes", "state"),
          localizations: Array(localizations["data"]).map do |localization|
            {
              locale: localization.dig("attributes", "locale"),
              name: localization.dig("attributes", "name"),
              state: localization.dig("attributes", "state"),
            }
          end,
          price_configured: !price_data.nil?,
          availability_configured: availability_configured?(availability_data, availability),
          review_screenshot_complete: asset_complete?(screenshot_data),
        }
      end

      def availability_configured?(availability_data, payload)
        return false unless availability_data

        attributes = availability_data["attributes"] || {}
        return true if attributes["availableInNewTerritories"] == true

        territories = availability_data.dig("relationships", "availableTerritories", "data")
        Array(territories).any? || Array(payload&.dig("included")).any?
      end

      def review_summary(review_detail, attachments_payload)
        {
          detail_id: review_detail&.dig("id"),
          notes_present: !review_detail&.dig("attributes", "notes").to_s.strip.empty?,
          attachments: Array(attachments_payload&.dig("data")).map do |attachment|
            {
              id: attachment["id"],
              file_name: attachment.dig("attributes", "fileName"),
              uploaded: attachment.dig("attributes", "uploaded") == true,
              asset_state: asset_state(attachment),
            }
          end,
        }
      end

      def asset_complete?(resource)
        return false unless resource

        state = asset_state(resource)
        resource.dig("attributes", "uploaded") == true || state == "COMPLETE"
      end

      def asset_state(resource)
        value = resource.dig("attributes", "assetDeliveryState")
        value.is_a?(Hash) ? value["state"] : value
      end

      def query(filter: nil, include: nil, sort: nil, limit: nil)
        values = {}
        filter&.each { |key, value| values["filter[#{key}]"] = value }
        values["include"] = include if include
        values["sort"] = sort if sort
        if limit.is_a?(Hash)
          limit.each { |key, value| values["limit[#{key}]"] = value }
        elsif limit
          values["limit"] = limit
        end
        URI.encode_www_form(values)
      end
    end

    class SubmissionGate
      READY_IAP_STATES = %w[
        READY_TO_SUBMIT
        WAITING_FOR_REVIEW
        IN_REVIEW
        APPROVED
      ].freeze
      READY_LOCALIZATION_STATES = READY_IAP_STATES
      VIDEO_EXTENSIONS = %w[.m4v .mov .mp4].freeze

      def initialize(snapshot, first_iap_associated:)
        @snapshot = snapshot
        @first_iap_associated = first_iap_associated
      end

      def blockers
        [].tap do |issues|
          append_build_issues(issues)
          append_iap_issues(issues)
          append_review_issues(issues)
        end
      end

      private

      def append_build_issues(issues)
        version = @snapshot[:version]
        unless version
          issues << "提出対象のApp Storeバージョンが見つかりません"
          return
        end

        build = version[:selected_build]
        unless build
          issues << "App Storeバージョンにビルドが選択されていません"
          return
        end

        if build[:processing_state] != "VALID"
          issues << "選択ビルドがVALIDではありません: #{build[:processing_state] || "不明"}"
        end
        expected = @snapshot[:expected_build_number]
        if expected && build[:number].to_s != expected.to_s
          issues << "選択ビルド#{build[:number]}がpubspecの#{expected}と一致しません"
        end
      end

      def append_iap_issues(issues)
        iap = @snapshot[:iap] || {}
        product_id = iap[:product_id] || IAP_PRODUCT_ID
        unless READY_IAP_STATES.include?(iap[:state])
          issues << "#{product_id} の状態が READY_TO_SUBMIT ではありません: #{iap[:state] || "不明"}"
        end

        localizations = Array(iap[:localizations])
        if localizations.empty?
          issues << "IAPローカリゼーションがありません"
        end
        localizations.each do |localization|
          next if READY_LOCALIZATION_STATES.include?(localization[:state])

          issues << "IAPローカリゼーション #{localization[:locale]} が提出可能ではありません: #{localization[:state] || "不明"}"
        end
        issues << "remove_ads の価格設定が確認できません" unless iap[:price_configured]
        issues << "remove_ads の配信地域が確認できません" unless iap[:availability_configured]
        unless iap[:review_screenshot_complete]
          issues << "remove_ads の審査用スクリーンショットが完了していません"
        end
        unless @first_iap_associated
          issues << "初回IAP remove_ads をApp Storeバージョンへ紐付けた確認がありません"
        end
      end

      def append_review_issues(issues)
        attachments = Array(@snapshot.dig(:review, :attachments))
        videos = attachments.select do |attachment|
          VIDEO_EXTENSIONS.include?(File.extname(attachment[:file_name].to_s).downcase)
        end
        complete_video = videos.any? do |attachment|
          attachment[:uploaded] && [nil, "COMPLETE"].include?(attachment[:asset_state])
        end
        issues << "Sandbox購入を示す審査用動画が添付されていません" unless complete_video
      end
    end

    class Formatter
      def self.render(snapshot, blockers: [])
        version = snapshot[:version] || {}
        build = version[:selected_build]
        iap = snapshot[:iap] || {}
        attachments = Array(snapshot.dig(:review, :attachments))

        lines = [
          "App Store Connect 監査: #{snapshot[:generated_at] || "local"}",
          "App version: #{version[:version_string] || "未検出"} / #{version[:state] || "不明"}",
          "Selected build: #{build ? "#{build[:number]} / #{build[:processing_state]}" : "なし"}",
          "Expected build: #{snapshot[:expected_build_number] || "不明"}",
          "IAP remove_ads: #{iap[:state] || "不明"}",
          "IAP localizations: #{Array(iap[:localizations]).map { |item| "#{item[:locale]}=#{item[:state]}" }.join(", ")}",
          "IAP price / availability / screenshot: #{iap[:price_configured]} / #{iap[:availability_configured]} / #{iap[:review_screenshot_complete]}",
          "Review attachments: #{attachments.map { |item| "#{item[:file_name]}=#{item[:asset_state] || item[:uploaded]}" }.join(", ")}",
        ]
        if blockers.empty?
          lines << "Submission gate: PASS"
        else
          lines << "Submission gate: BLOCKED"
          blockers.each { |blocker| lines << "- #{blocker}" }
        end
        lines.join("\n")
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  options = { json: false, gate: false, refresh_iap_localization: false }
  OptionParser.new do |parser|
    parser.banner = "Usage: app_store_connect_audit.rb [--json] [--gate] [--refresh-iap-localization]"
    parser.on("--json", "JSONで出力") { options[:json] = true }
    parser.on("--gate", "提出条件を満たさなければ終了コード1") { options[:gate] = true }
    parser.on("--refresh-iap-localization", "却下されたIAP表示情報を更新") do
      options[:refresh_iap_localization] = true
    end
  end.parse!

  key_id = ENV["ASC_KEY_ID"] || ENV["APP_STORE_CONNECT_API_KEY_KEY_ID"]
  issuer_id = ENV["ASC_ISSUER_ID"] || ENV["APP_STORE_CONNECT_API_KEY_ISSUER_ID"]
  key_path = ENV["ASC_KEY_PATH"] || ENV["APP_STORE_CONNECT_API_KEY_KEY_FILEPATH"]
  missing = { key_id: key_id, issuer_id: issuer_id, key_path: key_path }.filter_map do |name, value|
    name if value.to_s.empty?
  end
  abort("App Store Connect API認証情報が不足しています: #{missing.join(", ")}") unless missing.empty?

  begin
    client = TaxiShift::AppStoreConnect::Client.new(
      key_id: key_id,
      issuer_id: issuer_id,
      key_path: key_path,
    )
    if options[:refresh_iap_localization]
      result = TaxiShift::AppStoreConnect::IapLocalizationUpdater.new(
        client: client,
      ).update(
        name: "広告非表示",
        description: "カレンダーとサマリーに表示される広告を非表示にします。購入後はいつでも復元できます。",
      )
      state = result.dig("data", "attributes", "state")
      puts "IAPローカリゼーションを更新しました: #{state || "状態更新待ち"}"
    end
    snapshot = TaxiShift::AppStoreConnect::Audit.new(client: client).snapshot
    gate = TaxiShift::AppStoreConnect::SubmissionGate.new(
      snapshot,
      first_iap_associated: ENV["ASC_FIRST_IAP_ASSOCIATED"] == "true",
    )
    blockers = gate.blockers

    if options[:json]
      puts JSON.pretty_generate(snapshot.merge(blockers: blockers))
    else
      puts TaxiShift::AppStoreConnect::Formatter.render(snapshot, blockers: blockers)
    end
    exit(1) if options[:gate] && !blockers.empty?
  rescue TaxiShift::AppStoreConnect::ApiError => error
    warn("App Store Connect監査に失敗しました: #{error.message}")
    exit(2)
  end
end
