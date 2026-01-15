# jio_inet

[![pub package](https://img.shields.io/pub/v/jio_inet.svg)](https://pub.dev/packages/jio_inet)
[![GitHub release](https://img.shields.io/github/release/jiocoders/jio_inet.svg)](https://GitHub.com/jiocoders/jio_inet/releases/)
[![pub points](https://img.shields.io/pub/points/jio_inet?color=2E8B57&label=pub%20points)](https://pub.dev/packages/jio_inet/score)
[![jio_inet](https://github.com/JioCoders/jio_inet/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/JioCoders/jio_inet/actions/workflows/flutter-ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Description

Flutter plugin for both android and iOS to check the status of internet connection and listener when the internet
connection is changed.

## Features

- Current network connection check
- Listen to current network connection change

## Performance Metrics

- **Build Status:** The current status of the CI build.
- **Build Time:** Average build time for the CI.

## Getting Started

Published package url -
```
https://pub.dev/packages/jio_inet
```

To use this package :

- add the dependency to your [pubspec.yaml](https://github.com/JioCoders/jio_inet/blob/main/pubspec.yaml) file.

Installing:
> flutter pub add jio_inet

```yaml
dependencies:
  flutter:
    sdk: flutter
  jio_inet:
```

### How to use

```dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:jio_inet/jio_inet.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INet example',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0000AA),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _jioInetPlugin = JioInet();
  List<INetResult> _networkStatus = [INetResult.none];
  late StreamSubscription<List<INetResult>> _iNetSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();

    _iNetSubscription =
        _jioInetPlugin.iNetStatus.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(List<INetResult> result) async {
    setState(() {
      _networkStatus = result;
    });
    developer.log('Network-changed: $_networkStatus');
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late List<INetResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      result = await _jioInetPlugin.iNetType();
      debugPrint('iNetList::${result.toString()}');
    } on PlatformException catch (e) {
      developer.log('Failed to check iNet.', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('INet example'), elevation: 4),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(flex: 2),
          Text(
            'Network listener:',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Divider(),
          ListView(
            shrinkWrap: true,
            children: List.generate(
                _networkStatus.length,
                (index) => Center(
                      child: Text(
                        _networkStatus[index].toString(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    )),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _iNetSubscription.cancel();
  }
}

```

### Current network connection check

```dart
import 'package:jio_inet/jio_inet.dart';

  final _jioInetPlugin = JioInet();
  List<INetResult> _networkStatus = [INetResult.none];
  
  @override
  void initState() async {
    super.initState();
    _getNetworkConnection();
  }

Future<void> _getNetworkConnection() async {
  try {
    _networkStatus = await _jioInetPlugin.iNetType(); // current network connection result
    print('${_networkStatus.toString()}');
  } on PlatformException catch (e) {
    developer.log('Failed to check iNet.', error: e);
  }
}

```

### Listen whenever the connection is changed

```dart
import 'dart:async';
import 'package:jio_inet/jio_inet.dart';

final _jioInetPlugin = JioInet();
late StreamSubscription<List<INetResult>> _iNetSubscription;

@override
void initState() {
  super.initState();
  _iNetSubscription =
      _jioInetPlugin.iNetStatus.listen((List<INetResult> result) {
        print('iNetResult::${result.toString()}');
      });
}

@override
void dispose() {
  super.dispose();
  _iNetSubscription.cancel();
}
```

[![Pub](https://img.shields.io/pub/v/jio_inet.svg)](https://pub.dev/packages/jio_inet)
[![GitHub release](https://img.shields.io/github/release/jiocoders/jio_inet.svg)](https://GitHub.com/jiocoders/jio_inet/releases/)
[![pub points](https://img.shields.io/pub/points/jio_inet?color=2E8B57&label=pub%20points)](https://pub.dev/packages/jio_inet/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
