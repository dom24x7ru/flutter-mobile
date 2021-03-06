import 'dart:async';

import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class AppLoaderScreenPage extends StatefulWidget {
  const AppLoaderScreenPage({Key? key}) : super(key: key);

  @override
  State<AppLoaderScreenPage> createState() => _AppLoaderScreenPage();
}

class _AppLoaderScreenPage extends State<AppLoaderScreenPage> {
  String _version = '0.0.0';
  late String _loadMessage;
  late SocketClient _client;
  final List<dynamic> _listeners = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();

    setState(() => _loadMessage = 'идет загрузка данных...');

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;

      var listener = _client.on('loaded', this, (event, cont) async {
        try {
          String? token = await FirebaseMessaging.instance.getToken();
          if (token != null) {
            // сохраняем токен для пушей в БД на сервере
            _client.socket.emit('notification.saveToken', { 'token': token});
          }
        } catch (error) {
          debugPrint(error.toString());
        }

        final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

        if (!mounted) return;
        debugPrint('${DateTime.now()}: завершили загрузку и запустили приложение');
        Navigator.pushNamedAndRemoveUntil(context, initialLink != null ? initialLink.link.path : '/', (route) => false);
      });
      _listeners.add(listener);
      listener = _client.on('loading', this, (event, cont) {
        final channel = (event.eventData! as Map<String, dynamic>)['channel'];
        switch (channel) {
          case 'user':
            setState(() => _loadMessage = 'данные по пользователю загружены...');
            break;
          case 'posts':
            setState(() => _loadMessage = 'лента новостей загружена...');
            break;
          case 'flats':
            setState(() => _loadMessage = 'данные по квартирам загружены...');
            break;
        }
        _timer ??= Timer.periodic(const Duration(seconds: 5), (timer) {
            if (mounted) setState(() => _loadMessage = 'медленный интернет, подождите...');
            _timer!.cancel();
            _timer = null;
          });
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
    setState(() => _version = info.version);
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
            Text(_loadMessage, style: const TextStyle(color: Colors.black45)),
          ],
        ),
      ),
    );
  }
}