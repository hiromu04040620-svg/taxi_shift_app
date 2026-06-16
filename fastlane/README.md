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
