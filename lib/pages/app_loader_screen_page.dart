import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class AppLoaderScreenPage extends StatefulWidget {
  const AppLoaderScreenPage({Key? key}) : super(key: key);

  @override
  _AppLoaderScreenPage createState() => _AppLoaderScreenPage();
}

class _AppLoaderScreenPage extends State<AppLoaderScreenPage> {
  String _version = '0.0.0';
  late SocketClient _client;
  final List<dynamic> _listeners = [];

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;

      var listener = _client.on('loaded', this, (event, cont) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      });
      _listeners.add(listener);
      listener = _client.on('logout', this, (event, cont) {
        Navigator.pushNamedAndRemoveUntil(context, '/security/auth', (route) => false);
      });
      _listeners.add(listener);
    });
  }

  @override
  void dispose() {
    for (var listener in _listeners) {
      _client.off(listener);
    }
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/images/logo.png')),
            const Text('Dom24x7', style: TextStyle(fontSize: 50, color: Colors.blue)),
            Text('Версия: $_version', style: const TextStyle(color: Colors.blue)),
            const Text('идет загрузка данных...', style: TextStyle(color: Colors.black45)),
          ],
        ),
      ),
    );
  }
}