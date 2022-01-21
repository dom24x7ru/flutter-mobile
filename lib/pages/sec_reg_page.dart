import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/types/mobile_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecRegPage extends StatefulWidget {
  const SecRegPage({Key? key}) : super(key: key);

  @override
  State<SecRegPage> createState() => _SecRegPage();
}

class _SecRegPage extends State<SecRegPage> {
  late TextEditingController _cMobile;
  late TextEditingController _cMobileRepeat;
  late TextEditingController _cInviteCode;
  String? _mobileError;
  String? _mobileRepeatError;
  String? _inviteError;

  @override
  void initState() {
    super.initState();
    _cMobile = TextEditingController();
    _cMobileRepeat = TextEditingController();
    _cInviteCode = TextEditingController();
  }

  @override
  void dispose() {
    _cMobile.dispose();
    _cMobileRepeat.dispose();
    _cInviteCode.dispose();
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
                  child: Column(
                    children: [
                      TextField(
                        controller: _cMobile,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        onChanged: (String value) => { setState(() => { _mobileError = null }) },
                        decoration: InputDecoration(
                          prefix: const Text('+7 '),
                          labelText: 'Ваш номер телефона',
                          errorText: _mobileError
                        ),
                      ),
                      TextField(
                        controller: _cMobileRepeat,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        onChanged: (String value) => { setState(() => { _mobileRepeatError = null }) },
                        decoration: InputDecoration(
                          prefix: const Text('+7 '),
                          labelText: 'Повторить ваш номер телефона',
                          errorText: _mobileRepeatError
                        ),
                      ),
                      TextField(
                        controller: _cInviteCode,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        onChanged: (String value) => { setState(() => { _inviteError = null }) },
                        decoration: InputDecoration(
                          labelText: 'Введите код приглашения',
                          errorText: _inviteError
                        ),
                      ),
                    ],
                  )
              ),
              ElevatedButton(onPressed: () => { sendReg(context, store) }, child: Text('Зарегистрироваться'.toUpperCase())),
              const Text('- или -', style: TextStyle(color: Colors.black45)),
              TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/security/auth', (route) => false),
                  child: const Text('Авторизоваться'))
            ],
          )),
    );
  }

  void sendReg(BuildContext context, MainStore store) {
    final mobile = '7${_cMobile.text}';
    final invite = _cInviteCode.text;

    // валидация номера телефона
    if (mobile.length == 1) {
      setState(() => { _mobileError = 'Необходимо указать номер телефона' });
      return;
    } else if (mobile.length < 11) {
      setState(() => { _mobileError = 'Номер должен состоять из 10 цифр' });
      return;
    } else if (mobile != '7${_cMobileRepeat.text}') {
      setState(() => { _mobileRepeatError = 'Номера должны совпадать' });
      return;
    } else if (invite.isEmpty) {
      setState(() => { _inviteError = 'Необходимо указать код приглашения' });
      return;
    } else if(invite.length < 6) {
      setState(() => { _inviteError = 'Код приглашения должен состоять из 6 цифр' });
      return;
    }

    store.client.socket.emit('user.auth', { 'mobile': mobile, 'invite': invite }, (String name, dynamic error, dynamic data) {
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