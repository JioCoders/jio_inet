import 'dart:async';

import 'package:flutter/src/services/platform_channel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jio_inet/jio_inet.dart';
import 'package:jio_inet/jio_inet_platform_interface.dart';
import 'package:jio_inet/jio_inet_method_channel.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'service/inet_service.dart';
import 'service/mock_inet.dart';
import 'service/mock_inet.mocks.dart';

class MockJioInetPlatform
    with MockPlatformInterfaceMixin
    implements JioInetPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Stream<List<INetResult>> iNetStatus() {
    // Create a StreamController for managing the stream
    final controller = StreamController<List<INetResult>>();

    // Simulate emitting fake results over time
    Future<void>.delayed(Duration.zero, () async {
      for (int i = 0; i < 10; i++) {
        await Future.delayed(
            const Duration(milliseconds: 500)); // Simulate delay
        var value = [INetResult.none];
        value = i % 2 == 0 ? [INetResult.wifi] : [INetResult.mobile];
        controller.add(value); // Emit fake result
      }
      controller.close(); // Close the stream after emitting all data
    });

    return controller.stream;
  }

  @override
  Future<List<INetResult>> iNetType() {
    final List<INetResult> iNetList = [INetResult.wifi];
    return Future.value(iNetList);
  }

  @override
  MethodChannel getMethodChannel() {
    return const MethodChannel('jio_inet');
  }
}

void main() {
  final JioInetPlatform initialPlatform = JioInetPlatform.instance;
  final logger = Logger();

  test('$MethodChannelJioInet is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelJioInet>());
  });

  test('getPlatformVersion', () async {
    JioInet jioInetPlugin = JioInet();
    MockJioInetPlatform fakePlatform = MockJioInetPlatform();
    JioInetPlatform.instance = fakePlatform;

    final platformInfo = await jioInetPlugin.getPlatformVersion();
    logger.i('platformInfo::$platformInfo');
    expect(platformInfo, '42');
  });

  test('get Stream connection status', () async {
    JioInet jioInetPlugin = JioInet();
    MockJioInetPlatform fakePlatform = MockJioInetPlatform();
    JioInetPlatform.instance = fakePlatform;

    final stream = jioInetPlugin.iNetStatus;
    int i = 0;
    stream.listen((inetResult) {
      // Data is already printed inside the stream
      logger.i('Received inetResult:: $inetResult');
      i % 2 == 0
          ? expect(inetResult, [INetResult.wifi])
          : expect(inetResult, [INetResult.mobile]);
      i++;
    });
  });

  test('get Current connection type', () async {
    MockJioInetPlatform fakePlatform = MockJioInetPlatform();
    JioInetPlatform.instance = fakePlatform;

    final inetResult = await fakePlatform.iNetType();
    logger.i('inetResult:: $inetResult');
    expect(inetResult, [INetResult.wifi]);
  });

  /// Group test for Internet connectivity test with network call
  group('Group Test: InetService validation [none, mobile, wifi]', () {
    /// Logger: to print the value during running test
    late final Logger logger;

    /// connectivityService with mockConnectivity constructor
    late final InetService inetService;

    /// initialize resources
    /// run once before any tests in this group
    setUpAll(() {
      logger = Logger();
      mockInet = MockJioInet();
      inetService = InetService(mockInet);
    });

    /// free resources
    /// run once after all tests are finished
    tearDownAll(() {});

    test('Return false value when not connected', () async {
      // Arrange
      when(mockInet.iNetType())
          .thenAnswer((_) async => kResultNone); // simulate not connected

      // Act
      final inetResult = await inetService.validateNetworkConnection();
      logger.i('inetResult_none: $inetResult');

      // Assert
      expect(inetResult, false);
    });
    test('Return true value when connected to mobile', () async {
      // Arrange
      when(mockInet.iNetType())
          .thenAnswer((_) async => kResultMobile); // simulate mobile data

      // Act
      final inetResult = await inetService.validateNetworkConnection();
      logger.i('inetResult_mobile: $inetResult');

      // Assert
      expect(inetResult, true);
    });

    test('Return true value when connected to wifi', () async {
      // Arrange
      when(mockInet.iNetType())
          .thenAnswer((_) async => kResultWifi); // simulate wifi

      // Act
      final inetResult = await inetService.validateNetworkConnection();
      logger.i('inetResult_wifi: $inetResult');

      // Assert
      expect(inetResult, true);
    });
  });
}
