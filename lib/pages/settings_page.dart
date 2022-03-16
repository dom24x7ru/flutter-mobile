import 'package:dom24x7_flutter/widgets/checkbox_widget.dart';
import 'package:dom24x7_flutter/widgets/radio_widget.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/models/person_access.dart';
import 'package:dom24x7_flutter/models/resident.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AccessName { nothing, name, all }

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  AccessName? _accessName;
  bool _mobileLevel = false;
  bool _telegramLevel = false;

  late TextEditingController _cSurname;
  late TextEditingController _cName;
  late TextEditingController _cMidname;
  late TextEditingController _cTelegram;

  @override
  void initState() {
    super.initState();

    _cSurname = TextEditingController();
    _cName = TextEditingController();
    _cMidname = TextEditingController();
    _cTelegram = TextEditingController();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      load(store);
    });
  }

  @override
  void dispose() {
    _cSurname.dispose();
    _cName.dispose();
    _cMidname.dispose();
    _cTelegram.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    return Scaffold(
      appBar: Header(context, 'Настройки'),
      bottomNavigationBar: Footer(context, FooterNav.news),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            TextField(
                controller: _cSurname,
                decoration: const InputDecoration(
                    hintText: 'Фамилия'
                )
            ),
            TextField(
                controller: _cName,
                decoration: const InputDecoration(
                    hintText: 'Имя'
                )
            ),
            TextField(
                controller: _cMidname,
                decoration: const InputDecoration(
                    hintText: 'Отчество'
                )
            ),
            TextField(
                controller: _cTelegram,
                decoration: const InputDecoration(
                    hintText: 'Аккаунт в телеграм',
                    prefix: Text('@ ')
                )
            ),
            Container(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Настройки приватности', style: TextStyle(fontSize: 22.0)),
                      Container(padding: const EdgeInsets.all(5.0)),
                      const Text('Отображение имени', style: TextStyle(fontSize: 18.0)),
                      Dom24x7Radio<AccessName>(
                        value: AccessName.nothing,
                        groupValue: _accessName,
                        label: 'Не показывать имя',
                        onChanged: (AccessName? value) { setState(() { _accessName = value; }); }
                      ),
                      Dom24x7Radio<AccessName>(
                        value: AccessName.name,
                        groupValue: _accessName,
                        label: 'Показывать только имя',
                        onChanged: (AccessName? value) { setState(() { _accessName = value; }); }
                      ),
                      Dom24x7Radio<AccessName>(
                        value: AccessName.all,
                        groupValue: _accessName,
                        label: 'Показывать полностью',
                        onChanged: (AccessName? value) { setState(() { _accessName = value; }); }
                      ),
                      const Text('Отображение контактов', style: TextStyle(fontSize: 18.0)),
                      Dom24x7Checkbox(value: _mobileLevel, label: 'Показывать телефон', onChanged: (bool? value) => { setState(() => { _mobileLevel = value! }) }),
                      Dom24x7Checkbox(value: _telegramLevel, label: 'Показывать аккаунт телеграм (если указан)', onChanged: (bool? value) => { setState(() => { _telegramLevel = value! }) })
                    ]
                )
            ),
            Container(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                    children: [
                      const Text('Я хочу '),
                      InkWell(
                        child: const Text('выйти', style: TextStyle(color: Colors.blue)),
                        onTap: () => { logout(context, store) },
                      ),
                      const Text(' из приложения')
                    ]
                )
            ),
            ElevatedButton(
              onPressed: () => { save(store) },
              child: Text('Сохранить'.toUpperCase()),
            )
          ],
        )
      )
    );
  }

  void load(MainStore store) {
    if (store.user.value != null) {
      final user = store.user.value;
      if (user == null) return;
      if (user.person != null) {
        Person? person = user.person;
        _cSurname.text = person!.surname!;
        _cName.text = person.name!;
        _cMidname.text = person.midname!;
        _cTelegram.text = person.telegram != null ? person.telegram! : '';

        var access = person.access!.name;
        if (access!.level == Level.nothing) {
          _accessName = AccessName.nothing;
        } else if (access.level == Level.all) {
          if (access.format == NameFormat.name) {
            _accessName = AccessName.name;
          } else if (access.format == NameFormat.all) {
            _accessName = AccessName.all;
          }
        }

        _mobileLevel = person.access!.mobile!.level == Level.all;
        _telegramLevel = person.access!.telegram!.level == Level.all;
      }
    }
  }

  void logout(BuildContext context, MainStore store) async {
    store.client.socket.emit('user.logout', {});
    store.clear();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('authToken');
    Navigator.pushNamedAndRemoveUntil(context, '/security/auth', (route) => false);
  }

  void save(MainStore store) {
    var data = {
      'surname': _cSurname.text.trim(),
      'name': _cName.text.trim(),
      'midname': _cMidname.text.trim(),
      'telegram': _cTelegram.text.trim(),
      'access': {
        'name': {
          'level': _accessName == AccessName.nothing ? 'nothing' : 'all',
          'format': _accessName == AccessName.all ? 'all' : 'name'
        },
        'mobile': { 'level': _mobileLevel ? 'all' : 'friends' },
        'telegram': { 'level': _telegramLevel ? 'all' : 'friends' }
      }
    };
    store.client.socket.emit('user.saveProfile', data, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data != null && data['status'] == 'OK') {
        store.user.setPerson(Person.fromMap(data['person']));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Успешно сохранили'), backgroundColor: Colors.green)
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Сохранить не удалось. Попробуйте сохранить позже'), backgroundColor: Colors.red)
        );
      }
    });
  }
}