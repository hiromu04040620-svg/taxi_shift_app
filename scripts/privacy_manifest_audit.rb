#!/usr/bin/env ruby

require "json"
require "open3"
require "optparse"

module TaxiShift
  module PrivacyManifest
    class Validator
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

        if tracking == true && (!domains.is_a?(Array) || domains.empty?)
          issues << "NSPrivacyTracking=true の場合はNSPrivacyTrackingDomainsに1件以上必要です"
        elsif domains.is_a?(Array) && domains.any? && tracking != true
          issues << "NSPrivacyTrackingDomainsを指定する場合はNSPrivacyTracking=trueが必要です"
        end

        issues
      end
    end

    class Audit
      def initialize(validator: Validator.new)
        @validator = validator
      end

      def file(path)
        inspect_manifest(path, load_file(path))
      end

      def ipa(path)
        entries = run("unzip", "-Z1", path).lines.map(&:strip)
        entries.filter_map do |entry|
          next unless File.basename(entry) == "PrivacyInfo.xcprivacy"

          contents = run("unzip", "-p", path, entry)
          inspect_manifest(entry, load_contents(contents))
        end.flatten(1)
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
