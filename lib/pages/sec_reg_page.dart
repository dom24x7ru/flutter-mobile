import 'package:flutter/material.dart';

class SecRegPage extends StatefulWidget {
  const SecRegPage({Key? key}) : super(key: key);

  @override
  State<SecRegPage> createState() => _SecRegPage();
}

class _SecRegPage extends State<SecRegPage> {
  late TextEditingController _cMobile;
  late TextEditingController _cMobileRepeat;
  late TextEditingController _cInviteCode;

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
                        decoration: const InputDecoration(
                          prefix: Text('+7 '),
                          hintText: 'Ваш номер телефона',
                        ),
                      ),
                      TextField(
                        controller: _cMobileRepeat,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefix: Text('+7 '),
                          hintText: 'Повторить ваш номер телефона',
                        ),
                      ),
                      TextField(
                        controller: _cInviteCode,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Введите код приглашения',
                        ),
                      ),
                    ],
                  )
              ),
              ElevatedButton(onPressed: () {}, child: Text('Зарегистрироваться'.toUpperCase())),
              const Text('- или -', style: TextStyle(color: Colors.black45)),
              TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/security/auth', (route) => false),
                  child: const Text('Авторизоваться'))
            ],
          )),
    );
  }
}