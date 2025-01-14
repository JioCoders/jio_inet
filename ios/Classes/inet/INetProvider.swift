import Foundation

public enum INetType {
  case none
  case ethernet
  case wifi
  case cellular
  case other
}

public protocol INetProvider: NSObjectProtocol {
  typealias INetUpdateHandler = ([INetType]) -> Void
  
  var currentInetTypes: [INetType] { get }
  
  var iNetUpdateHandler: INetUpdateHandler? { get set }
  
  func start()
  
  func stop()
}
