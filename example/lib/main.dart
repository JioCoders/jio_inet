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

      String platformInfo = await _jioInetPlugin.getPlatformVersion() ??
          'Unknown platform version';
      developer.log('PlatformInfo::$platformInfo');
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
