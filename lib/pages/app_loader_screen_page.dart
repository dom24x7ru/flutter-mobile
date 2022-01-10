import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppLoaderScreenPage extends StatelessWidget {
  const AppLoaderScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final client = store.client;
    final loadedListener = client.on('loaded', this, (event, cont) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    });
    client.on('logout', this, (event, cont) {
      client.off(loadedListener);
      Navigator.pushNamedAndRemoveUntil(context, '/security/auth', (route) => false);
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Image(image: AssetImage('assets/images/logo.png')),
            Text('Dom24x7', style: TextStyle(fontSize: 50, color: Colors.blue)),
            Text('Версия 18 сборка 1', style: TextStyle(color: Colors.blue))
          ],
        ),
      ),
    );
  }
}