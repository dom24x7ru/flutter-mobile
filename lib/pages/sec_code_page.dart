import 'dart:async';

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
  final maxWait = 60;
  late TextEditingController _cMobileCode;
  late var listeners = [];
  late SocketClient client;
  late int waitSeconds ;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    waitSeconds = maxWait;
    _cMobileCode = TextEditingController();
    
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (waitSeconds > 0) {
        setState(() {
          waitSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _cMobileCode.dispose();
    for (var listener in listeners) {
      client.off(listener);
    }
    if (timer.isActive) timer.cancel();
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
                        maxLength: 4,
                        decoration: const InputDecoration(
                          labelText: 'Код авторизации',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: const Text('Мы вам сейчас позвоним. Введите последние 4 цифры номера входящего звонка', style: TextStyle(color: Colors.black45))
                      ),
                      waitSeconds != 0
                        ? Text('Если звонок не поступил, то можно перезапросить его через $waitSeconds сек.', style: const TextStyle(color: Colors.black45))
                        : Row(
                        children: [
                          const Text('Теперь вы можете вновь '),
                          InkWell(
                            child: const Text('запросить', style: TextStyle(color: Colors.blue)),
                            onTap: () => { recall(mobile, context, store) }
                          ),
                          const Text(' звонок')
                        ]
                      )
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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
    });
  }

  void recall(String mobile, BuildContext context, MainStore store) {
    setState(() {
      waitSeconds = maxWait;
    });
    if (mobile == '70000000000') return;

    store.client.socket.emit('user.auth', { 'mobile': mobile }, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data != null && data['status'] != 'OK') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Что-то пошло не так, попробуйте чуть позже'), backgroundColor: Colors.red)
        );
        return;
      }
    });
  }
}