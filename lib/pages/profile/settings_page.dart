import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/user/enums/level.dart';
import 'package:dom24x7_flutter/models/user/enums/name_format.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:dom24x7_flutter/models/house/resident.dart';
import 'package:dom24x7_flutter/models/user/user.dart';
import 'package:dom24x7_flutter/pages/profile/space_edit_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/checkbox_widget.dart';
import '../../widgets/radio_widget.dart';

enum AccessName { nothing, name, all }

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  User? _user;
  List<Flat>? _flats;
  Flat? _flat;
  AccessName? _accessName;
  bool _mobileLevel = false;
  bool _telegramLevel = false;

  late TextEditingController _cSurname;
  late TextEditingController _cName;
  late TextEditingController _cMidname;
  late TextEditingController _cFlat;
  late TextEditingController _cTelegram;

  late TextEditingController _cDeleteAccount;
  bool _enableDelBtn = false;

  @override
  void initState() {
    super.initState();

    _cSurname = TextEditingController();
    _cName = TextEditingController();
    _cMidname = TextEditingController();
    _cTelegram = TextEditingController();

    _cFlat = TextEditingController();
    _cFlat.addListener(_findFlat);

    _cDeleteAccount = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _load(store);
    });
  }

  @override
  void dispose() {
    _cSurname.dispose();
    _cName.dispose();
    _cMidname.dispose();
    _cTelegram.dispose();

    _cFlat.removeListener(_findFlat);
    _cFlat.dispose();

    _cDeleteAccount.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    return Scaffold(
      appBar: Header.get(context, '??????????????????'),
      bottomNavigationBar: const Footer(null),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            TextField(
                controller: _cSurname,
                decoration: const InputDecoration(
                    hintText: '??????????????'
                )
            ),
            TextField(
                controller: _cName,
                decoration: const InputDecoration(
                    hintText: '??????'
                )
            ),
            TextField(
                controller: _cMidname,
                decoration: const InputDecoration(
                    hintText: '????????????????'
                )
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: _cFlat,
                      enabled: _user == null || _user!.residents.isEmpty || _user!.residents[0].flat == null,
                      decoration: const InputDecoration(
                          hintText: '?????????????? ?????????? ????????????????'
                      )
                  )
                ),
                InkWell(
                  onTap: () {
                    if (_flat != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SpaceEditPage(_flat)));
                    }
                  },
                  child: Icon(Icons.edit_outlined, color: _flat != null ? Colors.black54 : Colors.black12)
                )
              ]
            ),
            Text(_getFlatInfo(_flat), style: const TextStyle(color: Colors.black45)),
            TextField(
                controller: _cTelegram,
                decoration: const InputDecoration(
                    hintText: '?????????????? ?? ????????????????',
                    prefix: Text('@ ')
                )
            ),
            Container(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('?????????????????? ??????????????????????', style: TextStyle(fontSize: 22.0)),
                      Container(padding: const EdgeInsets.all(5.0)),
                      const Text('?????????????????????? ??????????', style: TextStyle(fontSize: 18.0)),
                      Dom24x7Radio<AccessName>(
                        value: AccessName.nothing,
                        groupValue: _accessName,
                        label: '???? ???????????????????? ??????',
                        onChanged: (AccessName? value) { setState(() { _accessName = value; }); }
                      ),
                      Dom24x7Radio<AccessName>(
                        value: AccessName.name,
                        groupValue: _accessName,
                        label: '???????????????????? ???????????? ??????',
                        onChanged: (AccessName? value) { setState(() { _accessName = value; }); }
                      ),
                      Dom24x7Radio<AccessName>(
                        value: AccessName.all,
                        groupValue: _accessName,
                        label: '???????????????????? ??????????????????',
                        onChanged: (AccessName? value) { setState(() { _accessName = value; }); }
                      ),
                      const Text('?????????????????????? ??????????????????', style: TextStyle(fontSize: 18.0)),
                      Dom24x7Checkbox(value: _mobileLevel, label: '???????????????????? ??????????????', onChanged: (bool? value) => setState(() => _mobileLevel = value!)),
                      Dom24x7Checkbox(value: _telegramLevel, label: '???????????????????? ?????????????? ???????????????? (???????? ????????????)', onChanged: (bool? value) => setState(() => _telegramLevel = value!))
                    ]
                )
            ),
            Container(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                    children: [
                      const Text('?? ???????? '),
                      InkWell(
                        child: const Text('??????????', style: TextStyle(color: Colors.blue)),
                        onTap: () => _logout(context, store),
                      ),
                      const Text(' ???? ????????????????????')
                    ]
                )
            ),
            ElevatedButton(
              onPressed: () => _save(store),
              child: Text('??????????????????'.toUpperCase()),
            ),
            Card(
              color: Colors.redAccent,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('?? ???????? ?????????????? ???????? ??????????????', style: TextStyle(color: Colors.white)),
                    TextField(
                      controller: _cDeleteAccount,
                      onChanged: (String value) => _enableDelBtnCheck(),
                      decoration: const InputDecoration(
                        label: Text('?????? ???????????????? ?????????????? ?????????? "??????????????"', style: TextStyle(color: Colors.white))
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _enableDelBtn ? () => _delUser(store) : null,
                      child: Text('??????????????'.toUpperCase())
                    )
                  ]
                )
              ),
            )
          ],
        )
      )
    );
  }

  void _load(MainStore store) {
    setState(() {
      _user = store.user.value;
      _flats = store.flats.list;
    });
    if (store.user.value != null) {
      final user = store.user.value;
      if (user == null) return;
      if (user.person != null) {
        Person? person = user.person;
        _cSurname.text = person!.surname != null ? person.surname! : '';
        _cName.text = person.name != null ? person.name! : '';
        _cMidname.text = person.midname != null ? person.midname! : '';
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
      if (user.residents.isNotEmpty) {
        Resident? resident = user.residents[0];
        if (resident.flat != null) {
          _cFlat.text = resident.flat!.number.toString();
        }
      }
    }
  }

  void _findFlat() {
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

  String _getFlatInfo(Flat? flat) {
    if (flat == null) return '?????????????????? ?????????? ???????????????? ???? ???????????? ?? ????????';
    return Utilities.getFlatTitle(flat);
  }

  void _logout(BuildContext context, MainStore store) async {
    store.client.socket.emit('user.logout', {});
    store.clear();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('authToken');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pushNamedAndRemoveUntil(context, '/security/auth', (route) => false);
    });
  }

  void _save(MainStore store) {
    var data = {
      'surname': _cSurname.text.trim(),
      'name': _cName.text.trim(),
      'midname': _cMidname.text.trim(),
      'telegram': _cTelegram.text.trim(),
      'flat': _flat!.id,
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
        store.user.addResident(Resident.fromMap(data['resident']));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('?????????????? ??????????????????'), backgroundColor: Colors.green)
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('?????????????????? ???? ??????????????. ???????????????????? ?????????????????? ??????????'), backgroundColor: Colors.red)
        );
      }
    });
  }

  void _enableDelBtnCheck() {
    setState(() => _enableDelBtn = (_cDeleteAccount.text.toUpperCase() == '??????????????'));
  }

  void _delUser(MainStore store) {
    store.client.socket.emit('user.del', {}, (String name, dynamic error, dynamic data) async {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      store.clear();
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('authToken');
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushNamedAndRemoveUntil(context, '/security/auth', (route) => false);
      });
    });
  }
}