import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/mutual_help_item.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:dom24x7_flutter/pages/services/mutual_help/create_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/parallax_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../house/flat_page.dart';

class MutualHelpListPage extends StatefulWidget {
  final List<MutualHelpItem> list;
  const MutualHelpListPage(this.list, {Key? key}) : super(key: key);

  @override
  State<MutualHelpListPage> createState() => _MutualHelpListPageState();
}

class _MutualHelpListPageState extends State<MutualHelpListPage> {
  late List<MutualHelpItem> _list = [];
  late SocketClient _client;
  final List<dynamic> _listeners = [];

  @override
  void initState() {
    super.initState();
    setState(() => _list = widget.list);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      final category = _list.isNotEmpty ? _list[0].category : null;
      _client = store.client;

      var listener = _client.on('mutualHelp', this, (event, cont) {
        setState(() => _list = store.mutualHelp.list!.where((item) => item.category.id == category!.id).toList());
      });
      _listeners.add(listener);
    });
  }

  @override
  void dispose() {
    for (var listener in _listeners) {
      _client.off(listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final category = _list.isNotEmpty ? _list[0].category : null;
    final categoryName = category?.name;

    Widget? floatingActionButton;
    if (store.user.value!.residents.isNotEmpty) {
      floatingActionButton = FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MutualHelpCreatePage(null, category: category)));
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add)
      );
    }

    return Scaffold(
        appBar: Header(context, categoryName != null ? Utilities.getHeaderTitle(categoryName) : 'Неизвестная категория'),
        bottomNavigationBar: const Footer(FooterNav.services),
        floatingActionButton: floatingActionButton,
        body: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _list[index];
              List<Widget> infoList = [
                Row(children: [
                  const Text('Автор: '),
                  InkWell(
                      child: Text(_getAuthorName(item), style: const TextStyle(color: Colors.blue)),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(_getFlat(store, item))))
                  )
                ]),
                const Divider()
              ];
              infoList.add(const Divider());
              infoList.add(Text(item.body));

              if (item.person.id == store.user.value!.person!.id) {
                infoList.add(
                    ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MutualHelpCreatePage(item)));
                              },
                              icon: const Icon(Icons.edit_outlined)
                          ),
                          IconButton(
                              onPressed: () => _showDialog(context, item),
                              icon: const Icon(Icons.delete_outline)
                          )
                        ]
                    )
                );
              }

              return Card(
                  child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ParallaxListItem(
                              imageUrl: item.category.img,
                              title: Utilities.getHeaderTitle(item.title, 25),
                              horizontal: 0,
                              radius: 0,
                              aspectRatio: 16 / 6,
                            ),
                            ...infoList
                          ]
                      )
                  )
              );
            }));
  }

  String _getAuthorName(MutualHelpItem item) {
    Person person = item.person;
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
    if (fullName.trim().isEmpty) {
      final flat = item.flat;
      return 'сосед(ка) из ${Utilities.getFlatTitle(flat)}';
    }
    return fullName;
  }

  Flat _getFlat(MainStore store, MutualHelpItem item) {
    Flat flat = item.flat;
    final flats = store.flats.list!;
    for (Flat item in flats) {
      if (item.id == flat.id) return item;
    }
    return flat;
  }

  void _showDialog(BuildContext context, MutualHelpItem item) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: const Text('Удаление помощи'),
            content: const Text('Вы действительно хотите удалить свою помощь?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, 'cancel'),
                  child: const Text('Отмена')
              ),
              TextButton(
                  onPressed: () {
                    _delMutualHelp(context, item);
                    Navigator.pop(context, 'ok');
                  },
                  child: const Text('Удалить', style: TextStyle(color: Colors.red))
              )
            ]
        )
    );
  }

  void _delMutualHelp(BuildContext context, MutualHelpItem item) {
    final store = Provider.of<MainStore>(context, listen: false);
    store.client.socket.emit('mutualHelp.del', { 'id': item.id }, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data['status'] != 'OK') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Что-то пошло не так во время удаления помощи. Попробуйте позже.'), backgroundColor: Colors.red)
        );
        return;
      }
    });
  }
}