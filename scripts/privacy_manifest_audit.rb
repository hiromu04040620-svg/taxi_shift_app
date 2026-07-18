#!/usr/bin/env ruby

require "json"
require "open3"
require "optparse"

module TaxiShift
  module PrivacyManifest
    class Validator
      TRACKING_DOMAIN_PATTERN = %r{
        \A
        (?=.{1,253}\z)
        (?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+
        [A-Za-z](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?
        \z
      }x

      def issues(manifest)
        tracking = manifest["NSPrivacyTracking"]
        domains = manifest["NSPrivacyTrackingDomains"]
        issues = []

        if manifest.key?("NSPrivacyTracking") && ![true, false].include?(tracking)
          issues << "NSPrivacyTrackingはBooleanで指定してください"
        end
        if manifest.key?("NSPrivacyTrackingDomains") &&
           (!domains.is_a?(Array) || domains.any? { |domain| !domain.is_a?(String) })
          issues << "NSPrivacyTrackingDomainsは文字列の配列で指定してください"
          return issues
        end
        Array(domains).each do |domain|
          unless domain.match?(TRACKING_DOMAIN_PATTERN)
            issues << "NSPrivacyTrackingDomainsに無効なドメインがあります: #{domain}"
          end
        end

        if tracking == true && (!domains.is_a?(Array) || domains.empty?)
          issues << "NSPrivacyTracking=true の場合はNSPrivacyTrackingDomainsに1件以上必要です"
        elsif domains.is_a?(Array) && domains.any? && tracking != true
          issues << "NSPrivacyTrackingDomainsを指定する場合はNSPrivacyTracking=trueが必要です"
        end

        issues
      end
    end

    class Audit
      MAIN_APP_MANIFEST_PATTERN = %r{\APayload/[^/]+\.app/PrivacyInfo\.xcprivacy\z}

      def initialize(validator: Validator.new)
        @validator = validator
      end

      def file(path)
        inspect_manifest(path, load_file(path))
      end

      def ipa(path)
        entries = run("unzip", "-Z1", path).lines.map(&:strip)
        manifest_entries = entries.select do |entry|
          File.basename(entry) == "PrivacyInfo.xcprivacy"
        end
        findings = []
        unless manifest_entries.any? { |entry| entry.match?(MAIN_APP_MANIFEST_PATTERN) }
          findings << [path, "メインアプリのPrivacyInfo.xcprivacyがありません"]
        end
        manifest_entries.each do |entry|
          contents = run("unzip", "-p", path, entry)
          findings.concat(inspect_manifest(entry, load_contents(contents)))
        end

        findings
      end

      private

      def inspect_manifest(path, manifest)
        @validator.issues(manifest).map { |issue| [path, issue] }
      end

      def load_file(path)
        JSON.parse(run("plutil", "-convert", "json", "-o", "-", path))
      end

      def load_contents(contents)
        stdout, stderr, status = Open3.capture3(
          "plutil",
          "-convert",
          "json",
          "-o",
          "-",
          "-",
          stdin_data: contents,
        )
        raise "plutil failed: #{stderr.strip}" unless status.success?

        JSON.parse(stdout)
      end

      def run(*command)
        stdout, stderr, status = Open3.capture3(*command)
        raise "#{command.first} failed: #{stderr.strip}" unless status.success?

        stdout
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  options = { ipa: nil }
  OptionParser.new do |parser|
    parser.banner = "Usage: privacy_manifest_audit.rb [--ipa PATH] [MANIFEST ...]"
    parser.on("--ipa PATH", "IPA内の全PrivacyInfo.xcprivacyを検査") do |path|
      options[:ipa] = path
    end
  end.parse!

  repo_root = File.expand_path("..", __dir__)
  manifest_paths = ARGV.empty? ? [File.join(repo_root, "ios/Runner/PrivacyInfo.xcprivacy")] : ARGV
  audit = TaxiShift::PrivacyManifest::Audit.new
  findings = manifest_paths.flat_map { |path| audit.file(path) }
  findings.concat(audit.ipa(options[:ipa])) if options[:ipa]

  if findings.empty?
    puts "Privacy manifest audit: PASS"
  else
    puts "Privacy manifest audit: BLOCKED"
    findings.each { |path, issue| puts "- #{path}: #{issue}" }
    exit(1)
  end
end
