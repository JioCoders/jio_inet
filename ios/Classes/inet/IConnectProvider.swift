import Foundation

public enum IConnectType {
  case none
  case ethernet
  case wifi
  case cellular
  case other
}

public protocol IConnectProvider: NSObjectProtocol {
  typealias IConnectUpdateHandler = ([IConnectType]) -> Void
  
  var currentConnectTypes: [IConnectType] { get }
  
  var iConnectUpdateHandler: IConnectUpdateHandler? { get set }
  
  func start()
  
  func stop()
}
