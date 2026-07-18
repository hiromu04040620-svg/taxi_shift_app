require "minitest/autorun"
require_relative "../../scripts/privacy_manifest_audit"

class PrivacyManifestValidatorTest < Minitest::Test
  def test_tracking_enabled_requires_at_least_one_domain
    issues = TaxiShift::PrivacyManifest::Validator.new.issues(
      "NSPrivacyTracking" => true,
      "NSPrivacyTrackingDomains" => [],
    )

    assert_includes(
      issues,
      "NSPrivacyTracking=true の場合はNSPrivacyTrackingDomainsに1件以上必要です",
    )
  end

  def test_tracking_disabled_with_no_domains_is_valid
    issues = TaxiShift::PrivacyManifest::Validator.new.issues(
      "NSPrivacyTracking" => false,
    )

    assert_empty(issues)
  end

  def test_tracking_disabled_rejects_domains
    issues = TaxiShift::PrivacyManifest::Validator.new.issues(
      "NSPrivacyTracking" => false,
      "NSPrivacyTrackingDomains" => ["tracking.example.com"],
    )

    assert_includes(
      issues,
      "NSPrivacyTrackingDomainsを指定する場合はNSPrivacyTracking=trueが必要です",
    )
  end

  def test_tracking_enabled_with_domains_is_valid
    issues = TaxiShift::PrivacyManifest::Validator.new.issues(
      "NSPrivacyTracking" => true,
      "NSPrivacyTrackingDomains" => ["tracking.example.com"],
    )

    assert_empty(issues)
  end

  def test_tracking_domains_reject_url_components
    invalid_domains = [
      "https://tracking.example.com",
      "tracking.example.com/path",
      "tracking.example.com?source=app",
      "tracking.example.com/",
    ]

    invalid_domains.each do |domain|
      issues = TaxiShift::PrivacyManifest::Validator.new.issues(
        "NSPrivacyTracking" => true,
        "NSPrivacyTrackingDomains" => [domain],
      )

      assert_includes(
        issues,
        "NSPrivacyTrackingDomainsに無効なドメインがあります: #{domain}",
      )
    end
  end
end

class PrivacyManifestIpaAuditTest < Minitest::Test
  class StubAudit < TaxiShift::PrivacyManifest::Audit
    def initialize(entries)
      @entries = entries
      super()
    end

    private

    def load_contents(_contents)
      {}
    end

    def run(*command)
      return @entries.join("\n") if command[1] == "-Z1"
      return "" if command[1] == "-p"

      raise "unexpected command: #{command.join(" ")}"
    end
  end

  def test_ipa_requires_main_app_privacy_manifest
    findings = StubAudit.new([]).ipa("TaxiShift.ipa")

    assert_includes(
      findings,
      ["TaxiShift.ipa", "メインアプリのPrivacyInfo.xcprivacyがありません"],
    )
  end

  def test_sdk_manifest_does_not_replace_main_app_manifest
    entries = [
      "Payload/Runner.app/Frameworks/Example.framework/PrivacyInfo.xcprivacy",
    ]
    findings = StubAudit.new(entries).ipa("TaxiShift.ipa")

    assert_includes(
      findings,
      ["TaxiShift.ipa", "メインアプリのPrivacyInfo.xcprivacyがありません"],
    )
  end
end
