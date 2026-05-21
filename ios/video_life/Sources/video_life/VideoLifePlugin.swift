import Flutter
import UIKit

public class VideoLifePlugin: NSObject, FlutterPlugin {
    
  var player : BackgroundPlayer?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "video_life", binaryMessenger: registrar.messenger())
    let instance = VideoLifePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if (call.method == "start_life") {
          if (self.player == nil) {
              self.player = BackgroundPlayer.init()
          }
          self.player?.startPlayer()
      } else if (call.method == "close_life") {
          if (self.player != nil) {
              self.player?.stopPlayer()
          }
      } else {
          result("iOS " + UIDevice.current.systemVersion)
      }
  }
}
