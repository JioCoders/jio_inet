import 'package:jio_inet/src/enums.dart';

/// Parses the given list of states to a list of [INetResult].
List<INetResult> parseINetResults(List<Object?> objectList) {
  final List<String> resultList = List<String>.from(objectList);
  return resultList.map((result) {
    switch (result.trim()) {
      case 'bluetooth':
        return INetResult.bluetooth;
      case 'wifi':
        return INetResult.wifi;
      case 'ethernet':
        return INetResult.ethernet;
      case 'mobile':
        return INetResult.mobile;
      case 'vpn':
        return INetResult.vpn;
      case 'other':
        return INetResult.other;
      default:
        return INetResult.none;
    }
  }).toList();
}
