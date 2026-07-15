import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var adEnvironmentChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "com.sasame.takushiftokun/ad_environment",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "getEnvironment" else {
        result(FlutterMethodNotImplemented)
        return
      }
      result(Self.adStoreEnvironment())
    }
    adEnvironmentChannel = channel
  }

  private static func adStoreEnvironment() -> String {
#if DEBUG
    return "sandbox"
#else
    guard let receiptURL = Bundle.main.appStoreReceiptURL else {
      return "sandbox"
    }
    return receiptURL.lastPathComponent == "sandboxReceipt"
      ? "sandbox"
      : "production"
#endif
  }
}
