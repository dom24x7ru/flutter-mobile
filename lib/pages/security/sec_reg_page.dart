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
  late TextEditingController _cAddress;
  String? _mobileError;
  String? _mobileRepeatError;
  String? _inviteError;
  String? _addressError;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cMobile = TextEditingController();
    _cMobileRepeat = TextEditingController();
    _cInviteCode = TextEditingController();
    _cAddress = TextEditingController();
  }

  @override
  void dispose() {
    _cMobile.dispose();
    _cMobileRepeat.dispose();
    _cInviteCode.dispose();
    _cAddress.dispose();
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
                        onChanged: (String value) => setState(() => _mobileError = null),
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
                        onChanged: (String value) => setState(() => _mobileRepeatError = null),
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
                        onChanged: (String value) => setState(() {
                          _inviteError = null;
                          _addressError = null;
                        }),
                        decoration: InputDecoration(
                          labelText: 'Введите код приглашения',
                          errorText: _inviteError
                        ),
                      ),
                      const Text('- или -', style: TextStyle(color: Colors.black45)),
                      TextField(
                        controller: _cAddress,
                        onChanged: (String value) => setState(() {
                          _inviteError = null;
                          _addressError = null;
                        }),
                        decoration: InputDecoration(
                          labelText: 'Введите свой адрес',
                          errorText: _addressError
                        ),
                      )
                    ],
                  )
              ),
              ElevatedButton(
                  onPressed: _isLoading ? null : () => _sendReg(context, store),
                  child: Text('Зарегистрироваться'.toUpperCase())
              ),
              const Text('- или -', style: TextStyle(color: Colors.black45)),
              TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/security/auth', (route) => false),
                  child: const Text('Авторизоваться'))
            ],
          )),
    );
  }

  void _sendReg(BuildContext context, MainStore store) {
    final mobile = '7${_cMobile.text}';
    final invite = _cInviteCode.text;
    final address = _cAddress.text.trim();

    // валидация номера телефона
    if (mobile.length == 1) {
      setState(() => _mobileError = 'Необходимо указать номер телефона');
      return;
    } else if (mobile.length < 11) {
      setState(() => _mobileError = 'Номер должен состоять из 10 цифр');
      return;
    } else if (mobile != '7${_cMobileRepeat.text}') {
      setState(() => _mobileRepeatError = 'Номера должны совпадать');
      return;
    } else if (invite.isEmpty && address.isEmpty) {
      setState(() => _inviteError = 'Необходимо указать код приглашения');
      setState(() => _addressError = 'или указать свой адрес');
      return;
    } else if(address.isEmpty && invite.length < 6) {
      setState(() => _inviteError = 'Код приглашения должен состоять из 6 цифр');
      setState(() => _addressError = null);
      return;
    }

    var data = {
      'mobile': mobile,
      'invite': invite.isNotEmpty ? invite : null,
      'address': address.isNotEmpty ? address : null
    };
    setState(() => _isLoading = true);
    store.client.socket.emit('user.auth', data, (String name, dynamic error, dynamic data) {
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