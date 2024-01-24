import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var resourcesManager: ResourcesManager?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      keyChannel(controller: controller)
      
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func keyChannel(controller: FlutterViewController) {
        let channel = FlutterMethodChannel(name: "apiKey", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard call.method == "getKey" else {
              result(FlutterMethodNotImplemented)
              return
            }
            
            self?.resourcesManager = ResourcesManager()
            self?.resourcesManager?.getKey(result: result)
          })
    }
}
