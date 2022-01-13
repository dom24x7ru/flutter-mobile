import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/types/mobile_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecCodePage extends StatefulWidget {
  const SecCodePage({Key? key}) : super(key: key);

  @override
  State<SecCodePage> createState() => _SecCodePage();
}

class _SecCodePage extends State<SecCodePage> {
  late TextEditingController _cMobileCode;
  late var listeners = [];
  late SocketClient client;

  @override
  void initState() {
    super.initState();
    _cMobileCode = TextEditingController();
  }

  @override
  void dispose() {
    _cMobileCode.dispose();
    for (var listener in listeners) {
      client.off(listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final args = ModalRoute.of(context)!.settings.arguments as MobileType;
    final mobile = args.mobile;
    client = store.client;

    final listener = client.on('loaded', this, (event, cont) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    });
    listeners.add(listener);

    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _cMobileCode,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Код авторизации',
                        ),
                      ),
                      const Text('Мы вас сейчас позвоним. Введите последние 4 цифры номера входящего звонка', style: TextStyle(color: Colors.black45))
                    ],
                  )
              ),
              ElevatedButton(onPressed: () => sendCode(mobile, context, store), child: Text('Отправить'.toUpperCase()))
            ],
          )),
    );
  }

  void sendCode(String mobile, BuildContext context, MainStore store) {
    final code = _cMobileCode.text;
    store.client.socket.emit('user.auth', { 'mobile': mobile, 'code': code }, (String name, dynamic error, dynamic data) async {
      if (error != null) {
        // TODO: отобразить ошибку
        debugPrint('$error');
        return;
      }
      if (data != null && data['status'] != 'OK') {
        // TODO: сообщить что что-то пошло не так
        debugPrint('$data');
        return;
      }
    });
  }
}