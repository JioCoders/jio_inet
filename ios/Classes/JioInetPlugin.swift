import Flutter
import UIKit

public class JioInetPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

  private let iConnectProvider: IConnectProvider
  private var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.jiocoders/jio_inet", binaryMessenger: registrar.messenger())
    let streamChannel = FlutterEventChannel(name: "com.jiocoders/jio_inet_status", binaryMessenger: registrar.messenger())

    let iConnectProvider = PathMonitorIConnect()
    let instance = JioInetPlugin(iNetProvider: iConnectProvider)

    streamChannel.setStreamHandler(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  init(iConnectProvider: IConnectProvider) {
    self.iConnectProvider = iConnectProvider
    super.init()
    self.iConnectProvider.iConnectUpdateHandler = iConnectUpdateHandler
  }

  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    eventSink = nil
    iConnectProvider.stop()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "inet_type":
      result(statusFrom(connectTypes: iConnectProvider.currentConnectTypes))
    case "start_monitoring":
        iConnectProvider.start()
        result("started")
    case "stop_monitoring":
        iConnectProvider.stop()
        result("stopped")
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func statusFrom(iConnectType: IConnectType) -> String {
    switch iConnectType {
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

  private func statusFrom(connectTypes: [IConnectType]) -> [String] {
    return connectTypes.map {
      self.statusFrom(iConnectType: $0)
    }
  }

  private func iConnectUpdateHandler(iConnectTypes: [IConnectType]) {
    DispatchQueue.main.async {
      self.eventSink?(self.statusFrom(connectTypes: iConnectTypes))
    }
  }

  public func onListen(
    withArguments _: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    eventSink = events
    iConnectProvider.start()
    // Update this to handle a list
    iConnectUpdateHandler(iConnectTypes: iConnectProvider.currentConnectTypes)
    return nil
  }

  public func onCancel(withArguments _: Any?) -> FlutterError? {
    iConnectProvider.stop()
    eventSink = nil
    return nil
  }
}
