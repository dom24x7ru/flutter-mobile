import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/models/resident.dart';
import 'package:dom24x7_flutter/models/user.dart';
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
  User? _user;
  List<Flat>? _flats;
  Flat? _flat;
  AccessName? _accessName;

  late TextEditingController _cSurname;
  late TextEditingController _cName;
  late TextEditingController _cMidname;
  late TextEditingController _cFlat;
  late TextEditingController _cTelegram;

  @override
  void initState() {
    super.initState();

    _cSurname = TextEditingController();
    _cName = TextEditingController();
    _cMidname = TextEditingController();
    _cTelegram = TextEditingController();

    _cFlat = TextEditingController();
    _cFlat.addListener(findFlat);

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

    _cFlat.removeListener(findFlat);
    _cFlat.dispose();

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
                controller: _cFlat,
                enabled: _user == null || _user!.resident!.flat == null,
                decoration: const InputDecoration(
                    hintText: 'Введите номер квартиры'
                )
            ),
            Text(getFlatInfo(_flat), style: const TextStyle(color: Colors.black45)),
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
                      Row(
                          children: [
                            Radio<AccessName>(
                                value: AccessName.nothing,
                                groupValue: _accessName,
                                onChanged: (AccessName? value) {
                                  setState(() {
                                    _accessName = value;
                                  });
                                }
                            ),
                            const Text('Не показывать имя')
                          ]
                      ),
                      Row(
                          children: [
                            Radio<AccessName>(
                                value: AccessName.name,
                                groupValue: _accessName,
                                onChanged: (AccessName? value) {
                                  setState(() {
                                    _accessName = value;
                                  });
                                }
                            ),
                            const Text('Показывать только имя')
                          ]
                      ),
                      Row(
                          children: [
                            Radio<AccessName>(
                                value: AccessName.all,
                                groupValue: _accessName,
                                onChanged: (AccessName? value) {
                                  setState(() {
                                    _accessName = value;
                                  });
                                }
                            ),
                            const Text('Показывать полностью')
                          ]
                      ),
                      const Text('Отображение контактов', style: TextStyle(fontSize: 18.0)),
                      Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (bool? value) => {},
                            ),
                            const Text('Показывать телефон')
                          ]
                      ),
                      Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (bool? value) => {},
                            ),
                            const Text('Показывать аккаунт телеграм (если указан)')
                          ]
                      )
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
              onPressed: () => { },
              child: Text('Сохранить'.toUpperCase()),
            )
          ],
        )
      )
    );
  }

  void load(MainStore store) {
    setState(() {
      _user = store.user.value;
      _flats = store.flats.list;
    });
    if (store.user.value != null) {
      final user = store.user.value;
      if (user == null) return;
      if (user.person != null) {
        Person? person = user.person;
        _cSurname.text = person!.surname!;
        _cName.text = person.name!;
        _cMidname.text = person.midname!;
        _cTelegram.text = person.telegram!;
      }
      if (user.resident != null) {
        Resident? resident = user.resident;
        if (resident!.flat != null) {
          _cFlat.text = resident.flat!.number.toString();
        }
      }
    }
  }

  void findFlat() {
    if (_flats == null) return;
    for (Flat flat in _flats!) {
      if (flat.number.toString() == _cFlat.text) {
        setState(() {
          _flat = flat;
        });
        return;
      }
    }
  }

  String getFlatInfo(Flat? flat) {
    if (flat == null) return 'Указанный номер квартиры не найден в доме';
    return 'кв. №${flat.number}, этаж ${flat.floor}, подъезд ${flat.section}';
  }

  void logout(BuildContext context, MainStore store) async {
    store.client.socket.emit('user.logout', {});
    store.clear();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('authToken');
    Navigator.pushNamedAndRemoveUntil(context, '/security/auth', (route) => false);
  }
}