import 'package:jio_inet/jio_inet.dart';

class InetService {
  final JioInet _inet;

  InetService(this._inet);

  Future<bool> validateNetworkConnection() async {
    bool isConnected = false;
    var inetResultList = await _inet.iNetType();
    for (INetResult result in inetResultList) {
      switch (result) {
        case INetResult.mobile:
          isConnected = true;
        case INetResult.wifi:
          isConnected = true;
          // Not connected
        default:
      }
    }
    return isConnected;
  }
}
