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
end
