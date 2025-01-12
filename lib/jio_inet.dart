import 'package:collection/collection.dart';
import 'package:jio_inet/src/utils.dart';

import 'jio_inet_platform_interface.dart';
import 'src/enums.dart';

export 'package:jio_inet/src/enums.dart' show INetResult;

class JioInet {
  factory JioInet() {
    _singleton ??= JioInet._();
    return _singleton!;
  }

  JioInet._();

  static JioInet? _singleton;

  static JioInetPlatform get _platform {
    return JioInetPlatform.instance;
  }

  Future<String?> getPlatformVersion() {
    return _platform.getPlatformVersion();
  }

  Future<List<INetResult>> iNetType() async {
    final objectList = await _platform.iNetType();
    final List<INetResult> iNetList = parseINetResults(objectList);
    return iNetList;
  }

  Stream<List<INetResult>> get iNetStatus {
    final onConnectivityChanged =
        _platform.iNetStatus().map((parseINetResults));
    return onConnectivityChanged.distinct((a, b) => a.equals(b));
  }
}
