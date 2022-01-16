import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/invite.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  _InvitePage createState() => _InvitePage();
}

class _InvitePage extends State<InvitePage> {
  Invite? invite;
  List<Invite>? invites;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    setState(() {
      invites = store.invites.list;
    });

    return Scaffold(
      appBar: Header(context, 'Приглашения'),
      bottomNavigationBar: Footer(context, FooterNav.news),
      body: ListView.builder(
          itemCount: invites!.length + 3,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () => { sendInviteCode(store) },
                  child: Text('Сгенерировать код приглашения'.toUpperCase()),
                )
              );
            }
            if (index == 1) {
              if (this.invite == null) {
                return Container();
              } else {
                return Container(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                  child: Center(
                    child: Text(codeFormat(this.invite!.code!), style: const TextStyle(fontSize: 32.0)),
                  )
                );
              }
            }
            if (index == 2) {
              return Container(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: const Text('Последние 10 приглашений', style: TextStyle(color: Colors.black45))
              );
            }
            final invite = invites![index - 3];
            return Container(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(codeFormat(invite.code!), style: const TextStyle(fontSize: 18.0)),
                  Text(dateFormat(invite.createdAt!), style: const TextStyle(color: Colors.black45)),
                  flatInfoWidget(invite.flat)
                ]
              )
            );
          }
      )
    );
  }

  String codeFormat(String code) {
    return '${code.substring(0, 3)}-${code.substring(3, 6)}';
  }

  String dateFormat(int tm) {
    return DateFormat('dd.MM.y HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(tm));
  }

  Widget flatInfoWidget(Flat? flat) {
    if (flat == null) {
      return const Text('приглашением еще не воспользовались', style: TextStyle(color: Colors.red));
    } else {
      return Text('кв. №${flat.number}, этаж ${flat.floor}, подъезд ${flat.section}');
    }
  }

  void sendInviteCode(MainStore store) {
    final client = store.client;
    client.socket.emit('user.invite', {}, (String name, dynamic error, dynamic data) {
      if (error != null) {
        // TODO: отобразить ошибку
        debugPrint('$error');
      }
      if (data != null) {
        print(data['code']);
        final newInvite = Invite.fromMap({
          'id': data['id'],
          'createdAt': DateTime.now().millisecondsSinceEpoch,
          'code': data['code'],
          'used': false
        });
        store.invites.list!.insert(0, newInvite);
        setState(() {
          invite = newInvite;
        });
      }
    });
  }
}