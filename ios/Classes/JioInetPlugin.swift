import Flutter
import UIKit

public class JioInetPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

  private let iNetProvider: INetProvider
  private var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.jiocoders/jio_inet", binaryMessenger: registrar.messenger())
    let streamChannel = FlutterEventChannel(name: "com.jiocoders/jio_inet_status", binaryMessenger: registrar.messenger())

    let iNetProvider = PathMonitorINet()
    let instance = JioInetPlugin(iNetProvider: iNetProvider)

    streamChannel.setStreamHandler(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  init(iNetProvider: INetProvider) {
    self.iNetProvider = iNetProvider
    super.init()
    self.iNetProvider.iNetUpdateHandler = iNetUpdateHandler
  }

  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    eventSink = nil
    iNetProvider.stop()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "inet_type":
      result(statusFromList(connectTypes: iNetProvider.currentInetTypes))
    case "start_monitoring":
        iNetProvider.start()
        result("started")
    case "stop_monitoring":
        iNetProvider.stop()
        result("stopped")
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func statusFrom(iNetType: INetType) -> String {
    switch iNetType {
    case .wifi:
      return "wifi"
    case .cellular:
      return "mobile"
    case .ethernet:
      return "ethernet"
    case .other:
        return "other"
    case .none:
      return "none"
    }
  }

  private func statusFromList(connectTypes: [INetType]) -> [String] {
    return connectTypes.map {
      self.statusFrom(iNetType: $0)
    }
  }

  private func iNetUpdateHandler(iConnectTypes: [INetType]) {
    DispatchQueue.main.async {
      self.eventSink?(self.statusFromList(connectTypes: iConnectTypes))
    }
  }

  public func onListen(
    withArguments _: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    eventSink = events
    iNetProvider.start()
    // Update this to handle a list
    iNetUpdateHandler(iConnectTypes: iNetProvider.currentInetTypes)
    return nil
  }

  public func onCancel(withArguments _: Any?) -> FlutterError? {
    iNetProvider.stop()
    eventSink = nil
    return nil
  }
}
