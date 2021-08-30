import Flutter
import UIKit

public class SwiftInfoPlistPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "info_plist", binaryMessenger: registrar.messenger())
    let instance = SwiftInfoPlistPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getInfoPlistContents":
      guard let infoPlist = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
        result(FlutterError.init(code: "NATIVE_ERR", message: "Info.plist not found", details: nil))
        return
      }
      let dict = NSDictionary.init(contentsOf: infoPlist)
      result(dict)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
