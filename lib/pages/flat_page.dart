import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FlatPage extends StatefulWidget {
  final Flat flat;

  const FlatPage(this.flat, {Key? key}) : super(key: key);

  @override
  _FlatPageState createState() => _FlatPageState();
}

class _FlatPageState extends State<FlatPage> {
  bool loaded = false;
  List<Person> persons = [];

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final client = store.client;
    if (!loaded) {
      client.socket.emit('flat.info', { 'flatNumber': widget.flat.number}, (String name, dynamic error, dynamic data) {
        loaded = true;
        if (mounted) {
          setState(() => persons.clear());
          for (var item in data) {
            final person = Person.fromMap(item);
            if (!person.deleted) {
              setState(() => persons.add(Person.fromMap(item)));
            }
          }
        }
      });
    }

    return Scaffold(
      appBar: Header(context, 'кв. ${widget.flat.number} эт. ${widget.flat.floor} п. ${widget.flat.section}'),
      bottomNavigationBar: const Footer(FooterNav.house),
      body: ListView.builder(
        itemCount: persons.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            List<Widget> flatInfo = [
              Text('Квартира №${widget.flat.number}', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('Жильцов: ${widget.flat.residents.length}', style: const TextStyle(color: Colors.white60)),
            ];
            if (widget.flat.rooms != null) {
              flatInfo.add(
                Text('Комнат: ${widget.flat.rooms}', style: const TextStyle(color: Colors.white60))
              );
            }
            if (widget.flat.square != 0) {
              flatInfo.add(
                Text('Площадь: ${widget.flat.square} кв.м.', style: const TextStyle(color: Colors.white60))
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

          final person = persons[index - 1];
          List<Widget> children = [
            Text(getFullName(person), style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold))
          ];
          if (person.mobile != null) {
            children.add(InkWell(
              child: Text(getMobile(person), style: const TextStyle(color: Colors.blue)),
              onTap: () => { launch('tel:${person.mobile}') }
            ));
          }
          if (person.telegram != null) {
            children.add(InkWell(
              child: Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('${person.telegram}', style: const TextStyle(color: Colors.blue))
              ),
              onTap: () => launch('https://t.me/${person.telegram}'),
            ));
          }
          return Card(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children
              )
            )
          );
        }
      )
    );
  }

  String getFullName(Person person) {
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

  String getMobile(Person person) {
    if (person.mobile == null) return 'номер скрыт';
    return '+${person.mobile}';
  }
}
