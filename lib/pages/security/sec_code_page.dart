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
  final _maxWait = 60;
  late TextEditingController _cMobileCode;
  final _listeners = [];
  late SocketClient _client;
  late int _waitSeconds ;
  late Timer _timer;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _waitSeconds = _maxWait;
    _cMobileCode = TextEditingController();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_waitSeconds > 0) {
        setState(() => _waitSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _cMobileCode.dispose();
    for (var listener in _listeners) {
      _client.off(listener);
    }
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final args = ModalRoute.of(context)!.settings.arguments as MobileType;
    final mobile = args.mobile;
    _client = store.client;

    final listener = _client.on('loaded', this, (event, cont) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    });
    _listeners.add(listener);

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
                        child: const Text('Мы вам сейчас отправим смс сообщение с кодом авторизации', style: TextStyle(color: Colors.black45))
                      ),
                      _waitSeconds != 0
                        ? Text('Если смс сообщение не пришло, то можно перезапросить его через $_waitSeconds сек.', style: const TextStyle(color: Colors.black45))
                        : Row(
                        children: [
                          const Text('Теперь вы можете вновь '),
                          InkWell(
                            child: const Text('запросить', style: TextStyle(color: Colors.blue)),
                            onTap: () => _recall(mobile, context, store)
                          ),
                          const Text(' смс сообщение')
                        ]
                      )
                    ],
                  )
              ),
              ElevatedButton(
                  onPressed: _isLoading ? null : () => _sendCode(mobile, context, store),
                  child: Text('Отправить'.toUpperCase())
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const Text('Также можете вернуться на страницу ввода мобильного номера'),
                    ElevatedButton(
                      onPressed: () => { Navigator.pushNamedAndRemoveUntil(context, '/security/auth', (route) => false, arguments: MobileType(mobile)) },
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                      child: Text('Вернуться'.toUpperCase()),
                    )
                  ]
                ),
              )
            ],
          )),
    );
  }

  void _sendCode(String mobile, BuildContext context, MainStore store) {
    final code = _cMobileCode.text;
    setState(() => _isLoading = true);
    store.client.socket.emit('user.auth', { 'mobile': mobile, 'code': code }, (String name, dynamic error, dynamic data) async {
      setState(() => _isLoading = false);
      if (error != null) {
        if (error['code'] == 'USER.005') {
          // пользователь находится на другой ноде
          final url = error['extra']['url'];
          await store.client.connect(url);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _sendCode(mobile, context, store);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${error['code']}: ${error['message']}'),
                  backgroundColor: Colors.red)
          );
        }
        return;
      }
    });
  }

  void _recall(String mobile, BuildContext context, MainStore store) {
    setState(() => _waitSeconds = _maxWait);
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