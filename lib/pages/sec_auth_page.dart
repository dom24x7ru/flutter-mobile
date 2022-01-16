import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/types/mobile_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecAuthPage extends StatefulWidget {
  const SecAuthPage({Key? key}) : super(key: key);

  @override
  State<SecAuthPage> createState() => _SecAuthPage();
}

class _SecAuthPage extends State<SecAuthPage> {
  late TextEditingController _cMobile;

  @override
  void initState() {
    super.initState();
    _cMobile = TextEditingController();
  }

  @override
  void dispose() {
    _cMobile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: _cMobile,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefix: Text('+7 '),
                  hintText: 'Ваш номер телефона',
                ),
              )),
          ElevatedButton(
              onPressed: () => sendMobile(context, store),
              child: Text('Войти'.toUpperCase())),
          const Text('- или -', style: TextStyle(color: Colors.black45)),
          TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/security/reg', (route) => false),
              child: const Text('Зарегистрироваться'))
        ],
      )),
    );
  }

  void sendMobile(BuildContext context, MainStore store) {
    final mobile = '7${_cMobile.text}';
    // TODO: валидация номера телефона
    store.client.socket.emit('user.auth', { 'mobile': mobile }, (String name, dynamic error, dynamic data) {
      if (error != null) {
        // TODO: отобразить ошибку
        debugPrint('$error');
      }
      if (data != null && data['status'] != 'OK') {
        // TODO: сообщить что что-то пошло не так
        debugPrint('$data');
      }
      Navigator.pushNamedAndRemoveUntil(context, '/security/code', (route) => false, arguments: MobileType(mobile));
    });
  }
}
