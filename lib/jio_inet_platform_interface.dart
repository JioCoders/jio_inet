import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'jio_inet_method_channel.dart';

abstract class JioInetPlatform extends PlatformInterface {
  /// Constructs a JioInetPlatform.
  JioInetPlatform() : super(token: _token);

  static final Object _token = Object();

  static JioInetPlatform _instance = MethodChannelJioInet();

  /// The default instance of [JioInetPlatform] to use.
  ///
  /// Defaults to [MethodChannelJioInet].
  static JioInetPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [JioInetPlatform] when
  /// they register themselves.
  static set instance(JioInetPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  MethodChannel getMethodChannel() {
    throw UnimplementedError('methodChannel() has not been implemented.');
  }

  Future<List<Object?>> iNetType() {
    throw UnimplementedError('iNetType() has not been implemented.');
  }

  Stream<List<Object?>> iNetStatus() {
    throw UnimplementedError('iNetStatus() has not been implemented.');
  }
}
