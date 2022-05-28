import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/im/im_channel.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:dom24x7_flutter/pages/im/im_messages_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FlatPage extends StatefulWidget {
  Flat? flat;
  bool owner = false;
  bool top = false;
  bool bottom = false;

  FlatPage(this.flat, {Key? key}) : super(key: key);
  FlatPage.owner({Key? key}) : super(key: key) { owner = true; }
  FlatPage.top({Key? key}) : super(key: key) { top = true; }
  FlatPage.bottom({Key? key}) : super(key: key) { bottom = true; }

  @override
  _FlatPageState createState() => _FlatPageState();
}

class _FlatPageState extends State<FlatPage> {
  Flat? _flat;
  bool _loaded = false;
  final List<Person> _persons = [];

  @override
  void initState() {
    super.initState();
    if (widget.flat != null) {
      setState(() => _flat = widget.flat!);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final store = Provider.of<MainStore>(context, listen: false);
        final List<Flat> flats = store.flats.list!;
        final Flat ownerFlat = store.user.value!.residents[0].flat!;
        if (widget.owner) {
          // показать свою квартиру
          setState(() => _flat = ownerFlat);
        } else {
          final ownerFloorFlats = flats.where((flat) => flat.section == ownerFlat.section && flat.floor == ownerFlat.floor).toList();
          ownerFloorFlats.sort((flat1, flat2) {
            if (flat1.number > flat2.number) return 1;
            if (flat1.number < flat2.number) return -1;
            return 0;
          });
          final offset = ownerFloorFlats.where((flat) => flat.number == ownerFlat.number).toList().length - 1;

          final badFlats = flats.where((flat) => flat.section == null || flat.floor == null).toList();
          if (badFlats.isNotEmpty) {
            // данных не достаточно и можем не правильно отобраить соседа
            Navigator.pop(context, { 'error': 'Не у всех квартир указан подъезд и этаж. Нет возможности корректно определить соседа сверху и снизу' });
          } else if (widget.top) {
            // показать соседей сверху
            final topFlats = flats.where((flat) => flat.section == ownerFlat.section && flat.floor == ownerFlat.floor! + 1).toList();
            if (topFlats.isEmpty || topFlats.length < offset + 1) {
              Navigator.pop(context, { 'error': 'Нет соседей сверху' });
              return;
            }
            topFlats.sort((flat1, flat2) {
              if (flat1.number > flat2.number) return 1;
              if (flat1.number < flat2.number) return -1;
              return 0;
            });
            final topFlat = topFlats[offset];
            setState(() => _flat = topFlat);
          } else if (widget.bottom) {
            // показать соседей снизу
            final bottomFlats = flats.where((flat) => flat.section == ownerFlat.section && flat.floor == ownerFlat.floor! - 1).toList();
            if (bottomFlats.isEmpty || bottomFlats.length < offset + 1) {
              Navigator.pop(context, { 'error': 'Нет соседей снизу' });
              return;
            }
            bottomFlats.sort((flat1, flat2) {
              if (flat1.number > flat2.number) return 1;
              if (flat1.number < flat2.number) return -1;
              return 0;
            });
            final bottomFlat = bottomFlats[offset];
            setState(() => _flat = bottomFlat);
          } else {
            // нестандартная ситуация, ничего не показываем
            Navigator.pop(context);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final client = store.client;
    if (_flat == null) {
      return Scaffold(
        appBar: Header(context, ''),
        bottomNavigationBar: const Footer(FooterNav.house),
      );
    } else if (!_loaded) {
      client.socket.emit('flat.info', { 'flatNumber': _flat!.number}, (String name, dynamic error, dynamic data) {
        _loaded = true;
        if (mounted) {
          setState(() => _persons.clear());
          for (var item in data) {
            final person = Person.fromMap(item);
            if (!person.deleted) {
              if (person.mobile == null || person.mobile!.substring(0, 4) != '7000') {
                setState(() => _persons.add(Person.fromMap(item)));
              }
            }
          }
        }
      });
    }

    return Scaffold(
      appBar: Header(context, Utilities.getFlatTitle(_flat!)),
      bottomNavigationBar: const Footer(FooterNav.house),
      body: ListView.builder(
        itemCount: _persons.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            List<Widget> flatInfo = [
              Text('Квартира №${_flat!.number}', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('Жильцов: ${_persons.length}', style: const TextStyle(color: Colors.white60)),
            ];
            if (_flat!.rooms != null) {
              flatInfo.add(
                Text('Комнат: ${_flat!.rooms}', style: const TextStyle(color: Colors.white60))
              );
            }
            if (_flat!.square != 0) {
              flatInfo.add(
                Text('Площадь: ${_flat!.square} кв.м.', style: const TextStyle(color: Colors.white60))
              );
            }

            return Card(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: flatInfo
                )
              )
            );
          }

          return _residentCard(_persons[index - 1], store);
        }
      )
    );
  }

  String _getFullName(Person person) {
    String fullName = '';
    if (person.surname != null) {
      fullName += person.surname!;
    }
    if (person.name != null) {
      fullName += ' ${person.name!}';
    }
    if (person.midname != null) {
      fullName += ' ${person.midname!}';
    }
    if (fullName.isEmpty) {
      return 'Сосед не желает показывать имя';
    }
    return fullName;
  }

  String _getMobile(Person person) {
    if (person.mobile == null) return 'номер скрыт';
    return '+${person.mobile}';
  }

  void _privateChat(BuildContext context, MainStore store, Person person) {
    store.client.socket.emit('im.createPrivateChannel', { 'personId': person.id }, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }

      if (data['channel'] != null) {
        final channel = IMChannel.fromMap(data['channel']);
        Navigator.push(context, MaterialPageRoute(builder: (context) => IMMessagesPage(channel, Utilities.getChannelTitle(store.user.value!.person!, channel))));
      }
    });
  }

  Widget _residentStatus(Person person) {
    final type = person.extra!.type;
    if (type == 'user') return Container(padding: const EdgeInsets.all(5.0));

    late String label;
    late Color color;
    late Color backgroundColor;
    if (type == 'owner') {
      label = 'собственник';
      color = Colors.white;
      backgroundColor = Colors.blue;
    } else if (type == 'tenant') {
      label = 'арендатор';
      color = Colors.white;
      backgroundColor = Colors.green;
    } else {
      label = 'некорректный';
      color = Colors.white;
      backgroundColor = Colors.red;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Text(label, style: TextStyle(fontSize: 12.0, color: color)),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(20.0))
          ),
        )
      ]
    );
  }

  Widget _residentCard(Person person, MainStore store) {
    List<Widget> children = [
      _residentStatus(person),
      Text(_getFullName(person), style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
    ];
    if (person.mobile != null) {
      children.add(InkWell(
          child: Text(_getMobile(person), style: const TextStyle(color: Colors.blue)),
          onTap: () => { launchUrl(Uri.parse('tel:${person.mobile}')) }
      ));
    }
    if (person.telegram != null) {
      children.add(InkWell(
        child: Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text('${person.telegram}', style: const TextStyle(color: Colors.blue))
        ),
        onTap: () => launchUrl(Uri.parse('https://t.me/${person.telegram}')),
      ));
    }
    if (person.id != store.user.value!.person!.id) {
      children.add(
          ButtonBar(
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () => _privateChat(context, store, person),
                )
              ]
          )
      );
    }
    return Card(
        child: Container(
            padding: const EdgeInsets.only(left: 15.0, right: 5.0, top: 5.0, bottom: 5.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children
            )
        )
    );
  }
}
