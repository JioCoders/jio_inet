import Foundation
import Network

public class PathMonitorIConnect: NSObject, IConnectProvider {

  // Use .utility, as it is intended for tasks that the user does not track actively.
  // See: https://developer.apple.com/documentation/dispatch/dispatchqos
//  private let queue = DispatchQueue.global(qos: .utility)
  private let queue = DispatchQueue(label: "NetworkMonitorQueue")

  private var pathMonitor: NWPathMonitor?

  private func connectFrom(path: NWPath) -> [INetType] {
    var types: [INetType] = []
    
    // Check for connectivity and append to types array as necessary
    if path.status == .satisfied {
      if path.usesInterfaceType(.wifi) {
        types.append(.wifi)
      }
      if path.usesInterfaceType(.cellular) {
        types.append(.cellular)
      }
      if path.usesInterfaceType(.wiredEthernet) {
        types.append(.ethernet)
      }
      if path.usesInterfaceType(.other) {
        types.append(.other)
      }
    }
    
    return types.isEmpty ? [.none] : types
  }

  public var currentConnectTypes: [INetType] {
    let path = ensurePathMonitor().currentPath
    return connectFrom(path: path)
  }

  public var iConnectUpdateHandler: IConnectUpdateHandler?

  override init() {
    super.init()
    _ = ensurePathMonitor()
  }

  public func start() {
    _ = ensurePathMonitor()
  }

  public func stop() {
    pathMonitor?.cancel()
    pathMonitor = nil
  }

  @discardableResult
  private func ensurePathMonitor() -> NWPathMonitor {
    if (pathMonitor == nil) {
      let pathMonitor = NWPathMonitor()
      pathMonitor.start(queue: queue)
      pathMonitor.pathUpdateHandler = pathUpdateHandler
      self.pathMonitor = pathMonitor
    }
    return self.pathMonitor!
  }

  private func pathUpdateHandler(path: NWPath) {
    iConnectUpdateHandler?(connectFrom(path: path))
  }
}
