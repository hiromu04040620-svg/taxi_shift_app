fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios verify_release

```sh
[bundle exec] fastlane ios verify_release
```

Run formatting, analysis, Flutter tests, and release script tests

### ios build_ipa

```sh
[bundle exec] fastlane ios build_ipa
```

Build App Store IPA from Flutter pubspec version

### ios upload_testflight

```sh
[bundle exec] fastlane ios upload_testflight
```

Build and upload IPA to App Store Connect / TestFlight

### ios asc_status

```sh
[bundle exec] fastlane ios asc_status
```

Show the current App Store version, build, IAP, and review attachment state

### ios asc_preflight

```sh
[bundle exec] fastlane ios asc_preflight
```

Stop unless every API-visible App Review submission condition passes

### ios refresh_iap_localization

```sh
[bundle exec] fastlane ios refresh_iap_localization
```

Update the editable Japanese remove_ads localization through the API

### ios bump_build_number

```sh
[bundle exec] fastlane ios bump_build_number
```

Choose a reusable local build number or increment past App Store Connect

### ios release_candidate

```sh
[bundle exec] fastlane ios release_candidate
```

Verify, build, upload, wait for VALID, and select the build for App Review

### ios sync_review_notes

```sh
[bundle exec] fastlane ios sync_review_notes
```

Update App Review notes from fastlane/review_notes.txt

### ios upload_review_video

```sh
[bundle exec] fastlane ios upload_review_video
```

Upload a physical-device Sandbox purchase recording to App Review

### ios submit_review

```sh
[bundle exec] fastlane ios submit_review
```

Submit the selected version after IAP and recording preflight passes

### ios prepare_screenshots

```sh
[bundle exec] fastlane ios prepare_screenshots
```

Prepare App Store screenshot files from the current simulator screenshots

### ios upload_screenshots

```sh
[bundle exec] fastlane ios upload_screenshots
```

Upload screenshots only to App Store Connect

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
