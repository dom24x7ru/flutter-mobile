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
  String? _errorText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cMobile = TextEditingController();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final args = ModalRoute.of(context)!.settings.arguments as MobileType;
        final mobile = args.mobile;
        _cMobile.text = mobile.substring(1, 11);
      }
    });
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
                maxLength: 10,
                onChanged: (String value) => { setState(() => { _errorText = null }) },
                decoration: InputDecoration(
                  prefix: const Text('+7 '),
                  labelText: 'Ваш номер телефона',
                  errorText: _errorText
                ),
              )),
          ElevatedButton(
              onPressed: _isLoading ? null : () => _sendMobile(context, store),
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

  void _sendMobile(BuildContext context, MainStore store) {
    final mobile = '7${_cMobile.text}';

    // валидация номера телефона
    if (mobile.length == 1) {
      setState(() => { _errorText = 'Необходимо указать номер телефона' });
      return;
    } else if (mobile.length < 11) {
      setState(() => { _errorText = 'Номер должен состоять из 10 цифр' });
      return;
    }

    if (mobile == '70000000000') {
      // тестовый пользователь
      Navigator.pushNamedAndRemoveUntil(context, '/security/code', (route) => false, arguments: MobileType(mobile));
      return;
    }

    setState(() => _isLoading = true);
    store.client.socket.emit('user.auth', { 'mobile': mobile }, (String name, dynamic error, dynamic data) {
      setState(() => _isLoading = false);
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
      Navigator.pushNamedAndRemoveUntil(context, '/security/code', (route) => false, arguments: MobileType(mobile));
    });
  }
}
