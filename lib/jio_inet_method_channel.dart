import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'jio_inet_platform_interface.dart';

/// An implementation of [JioInetPlatform] that uses method channels.
class MethodChannelJioInet extends JioInetPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.jiocoders/jio_inet');

  /// The event channel used to receive ConnectivityResult changes from the native platform.
  @visibleForTesting
  EventChannel eventChannel =
      const EventChannel('com.jiocoders/jio_inet_status');

  @override
  MethodChannel getMethodChannel() {
    return methodChannel;
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<List<Object?>> iNetType() async {
    if (Platform.isIOS) {
      await methodChannel.invokeMethod('start_monitoring');
    }
    final connection = await methodChannel.invokeMethod('inet_type');
    if (Platform.isIOS) {
      await methodChannel.invokeMethod('stop_monitoring');
    }
    return connection;
  }

  @override
  Stream<List<Object?>> iNetStatus() {
    Stream<List<Object?>> onConnectivityChanged =
        eventChannel.receiveBroadcastStream().map((dynamic result) => result);
    return onConnectivityChanged;
  }
}
