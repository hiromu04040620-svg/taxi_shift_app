require "minitest/autorun"
require_relative "../../scripts/app_store_connect_audit"

class AppStoreConnectSubmissionGateTest < Minitest::Test
  def test_ready_snapshot_has_no_blockers
    gate = TaxiShift::AppStoreConnect::SubmissionGate.new(
      ready_snapshot,
      first_iap_associated: true,
    )

    assert_empty(gate.blockers)
  end

  def test_iap_already_waiting_for_review_has_no_iap_blockers
    snapshot = ready_snapshot
    snapshot[:iap][:state] = "WAITING_FOR_REVIEW"
    snapshot[:iap][:localizations][0][:state] = "WAITING_FOR_REVIEW"

    blockers = TaxiShift::AppStoreConnect::SubmissionGate.new(
      snapshot,
      first_iap_associated: true,
    ).blockers

    assert_empty(blockers)
  end

  def test_rejected_iap_and_localization_are_blockers
    snapshot = ready_snapshot
    snapshot[:iap][:state] = "DEVELOPER_ACTION_NEEDED"
    snapshot[:iap][:localizations][0][:state] = "REJECTED"

    blockers = TaxiShift::AppStoreConnect::SubmissionGate.new(
      snapshot,
      first_iap_associated: true,
    ).blockers

    assert_includes(blockers, "remove_ads の状態が READY_TO_SUBMIT ではありません: DEVELOPER_ACTION_NEEDED")
    assert_includes(blockers, "IAPローカリゼーション ja が提出可能ではありません: REJECTED")
  end

  def test_selected_build_and_purchase_video_are_required
    snapshot = ready_snapshot
    snapshot[:version][:selected_build] = nil
    snapshot[:review][:attachments] = []

    blockers = TaxiShift::AppStoreConnect::SubmissionGate.new(
      snapshot,
      first_iap_associated: true,
    ).blockers

    assert_includes(blockers, "App Storeバージョンにビルドが選択されていません")
    assert_includes(blockers, "Sandbox購入を示す審査用動画が添付されていません")
  end

  def test_first_iap_association_requires_explicit_confirmation
    blockers = TaxiShift::AppStoreConnect::SubmissionGate.new(
      ready_snapshot,
      first_iap_associated: false,
    ).blockers

    assert_includes(
      blockers,
      "初回IAP remove_ads をApp Storeバージョンへ紐付けた確認がありません",
    )
  end

  private

  def ready_snapshot
    {
      expected_build_number: "9",
      version: {
        id: "version-id",
        version_string: "1.0",
        state: "PREPARE_FOR_SUBMISSION",
        selected_build: {
          id: "build-id",
          number: "9",
          processing_state: "VALID",
        },
      },
      iap: {
        product_id: "remove_ads",
        state: "READY_TO_SUBMIT",
        localizations: [
          { locale: "ja", state: "READY_TO_SUBMIT" },
        ],
        price_configured: true,
        availability_configured: true,
        review_screenshot_complete: true,
      },
      review: {
        attachments: [
          {
            file_name: "sandbox_purchase.mp4",
            uploaded: true,
            asset_state: "COMPLETE",
          },
        ],
      },
    }
  end
end

class AppStoreConnectIapLocalizationUpdaterTest < Minitest::Test
  class FakeClient
    attr_reader :path, :body

    def patch(path, body:)
      @path = path
      @body = body
      { "data" => { "attributes" => { "state" => "READY_TO_SUBMIT" } } }
    end
  end

  def test_updates_the_rejected_localization_through_the_official_endpoint
    client = FakeClient.new
    updater = TaxiShift::AppStoreConnect::IapLocalizationUpdater.new(
      client: client,
      localization_id: "localization-id",
    )

    updater.update(name: "広告非表示", description: "広告を非表示にします。")

    assert_equal(
      "/v1/inAppPurchaseLocalizations/localization-id",
      client.path,
    )
    assert_equal(
      {
        data: {
          type: "inAppPurchaseLocalizations",
          id: "localization-id",
          attributes: {
            name: "広告非表示",
            description: "広告を非表示にします。",
          },
        },
      },
      client.body,
    )
  end
end
