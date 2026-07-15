# Fastlane release workflow

## What is automated

Fastlane and the App Store Connect API handle:

1. Formatting, static analysis, Flutter tests, and Ruby release-script tests.
2. Choosing the next valid build number.
3. Building and uploading the IPA.
4. Waiting for App Store Connect processing and selecting the build for version 1.0.
5. Updating App Review notes.
6. Uploading the physical-device Sandbox purchase recording.
7. Checking IAP, localization, price, availability, screenshot, build, and attachment state.
8. Creating and submitting the App Review submission.

The private key remains at `fastlane/AuthKey_CRVY464U3R.p8` and is ignored by Git.

To use another key, override the local defaults:

```sh
export APP_STORE_CONNECT_API_KEY_KEY_ID="Key ID"
export APP_STORE_CONNECT_API_KEY_ISSUER_ID="Issuer ID"
export APP_STORE_CONNECT_API_KEY_KEY_FILEPATH="/absolute/path/to/AuthKey_XXXXXXXXXX.p8"
```

## Commands

Show the current App Store Connect state:

```sh
bundle exec fastlane ios asc_status
```

Refresh the Japanese `remove_ads` metadata after it becomes editable:

```sh
bundle exec fastlane ios refresh_iap_localization
```

Verify, build, upload, wait, and select the build:

```sh
bundle exec fastlane ios release_candidate
```

If the current IPA only needs to be uploaded again:

```sh
bundle exec fastlane ios upload_testflight skip_build:true
```

Upload the physical-device Sandbox purchase recording:

```sh
bundle exec fastlane ios upload_review_video path:/absolute/path/sandbox_purchase.mp4
```

Run the submission gate:

```sh
ASC_FIRST_IAP_ASSOCIATED=true bundle exec fastlane ios asc_preflight
```

Submit after the gate passes:

```sh
ASC_FIRST_IAP_ASSOCIATED=true bundle exec fastlane ios submit_review
```

## One required web-only step for the first IAP

Apple's API rejects localization edits while that localization is in `REJECTED`. On the `remove_ads` page, first cancel the rejected localization change in the web UI. Then run `refresh_iap_localization` and confirm that the product changes from `DEVELOPER_ACTION_NEEDED` to `READY_TO_SUBMIT`.

Apple also requires the first In-App Purchase to be selected on the App Store version page before that version is submitted. Select `remove_ads` in the version page's "In-App Purchases and Subscriptions" section. Only set `ASC_FIRST_IAP_ASSOCIATED=true` after confirming that selection.

Do not submit until the physical-device Sandbox purchase succeeds and its complete recording is attached.

Also confirm that the Paid Apps Agreement is in effect and that the Support URL is `https://hiromu04040620-svg.github.io/taxi_shift_app/`. These account and first-IAP checks aren't exposed completely by the API.
