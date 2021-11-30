import 'package:flutter/material.dart';

class AppLoaderScreenPage extends StatefulWidget {
  const AppLoaderScreenPage({Key? key}) : super(key: key);

  @override
  _AppLoaderScreenPageState createState() => _AppLoaderScreenPageState();
}

class _AppLoaderScreenPageState extends State<AppLoaderScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
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