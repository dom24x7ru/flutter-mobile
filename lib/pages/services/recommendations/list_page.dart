import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/models/recommendation.dart';
import 'package:dom24x7_flutter/pages/services/recommendations/create_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/parallax_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../house/flat_page.dart';

class RecommendationsListPage extends StatefulWidget {
  final List<Recommendation> list;
  const RecommendationsListPage(this.list, {Key? key}) : super(key: key);

  @override
  State<RecommendationsListPage> createState() => _RecommendationsListPageState();
}

class _RecommendationsListPageState extends State<RecommendationsListPage> {
  late List<Recommendation> _list = [];
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

      var listener = _client.on('recommendations', this, (event, cont) {
        setState(() => _list = store.recommendations.list!.where((item) => item.category.id == category!.id).toList());
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendationCreatePage(null, category: category)));
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
              final recommendation = _list[index];
              final extra = recommendation.extra;
              List<Widget> infoList = [
                Row(children: [
                  const Text('Автор: '),
                  InkWell(
                      child: Text(_getAuthorName(recommendation), style: const TextStyle(color: Colors.blue)),
                      onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(_getFlat(store, recommendation)))) })
                ]),
                const Divider()
              ];
              if (extra.address != null) {
                infoList.add(Row(children: [
                  const Icon(Icons.location_on),
                  Text(extra.address!)
                ]));
              }
              if (extra.phone != null) {
                infoList.add(Row(children: [
                  const Icon(Icons.phone),
                  InkWell(
                      child: Text('+${extra.phone!}', style: const TextStyle(color: Colors.blue)),
                      onTap: () => { launchUrl(Uri.parse('tel:${extra.phone}')) }
                  )
                ]));
              }
              if (extra.instagram != null) {
                infoList.add(Row(children: [
                  const FaIcon(FontAwesomeIcons.instagram),
                  InkWell(
                      child: Text(' ${extra.instagram!}', style: const TextStyle(color: Colors.blue)),
                      onTap: () => { launchUrl(Uri.parse('https://www.instagram.com/${extra.instagram}/')) }
                  )
                ]));
              }
              if (extra.telegram != null) {
                infoList.add(Row(children: [
                  const FaIcon(FontAwesomeIcons.telegram),
                  InkWell(
                      child: Text(' ${extra.telegram!}', style: const TextStyle(color: Colors.blue)),
                      onTap: () => { launchUrl(Uri.parse('https://t.me/${extra.telegram}')) }
                  )
                ]));
              }
              if (extra.site != null) {
                infoList.add(Row(children: [
                  const Icon(Icons.language),
                  InkWell(
                      child: Text(extra.site!, style: const TextStyle(color: Colors.blue)),
                      onTap: () => { launchUrl(Uri.parse('https://${extra.site}')) }
                  )
                ]));
                if (extra.email != null) {
                  infoList.add(Row(children: [
                    const Icon(Icons.alternate_email),
                    InkWell(
                        child: Text(extra.email!, style: const TextStyle(color: Colors.blue)),
                        onTap: () => { launchUrl(Uri.parse('mailto:${extra.email}')) }
                    )
                  ]));
                }
              }
              infoList.add(const Divider());
              infoList.add(Text(recommendation.body));

              if (recommendation.person.id == store.user.value!.person!.id) {
                infoList.add(
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendationCreatePage(recommendation)));
                        },
                        icon: const Icon(Icons.edit_outlined)
                      ),
                      IconButton(
                        onPressed: () => _showDialog(context, recommendation),
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
                              imageUrl: recommendation.category.img,
                              title: Utilities.getHeaderTitle(recommendation.title, 25),
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

  String _getAuthorName(Recommendation recommendation) {
    Person person = recommendation.person;
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
      final flat = recommendation.flat;
      return 'сосед(ка) из ${Utilities.getFlatTitle(flat)}';
    }
    return fullName;
  }

  Flat _getFlat(MainStore store, Recommendation recommendation) {
    Flat flat = recommendation.flat;
    final flats = store.flats.list!;
    for (Flat item in flats) {
      if (item.id == flat.id) return item;
    }
    return flat;
  }

  void _showDialog(BuildContext context, Recommendation recommendation) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: const Text('Удаление рекомендации'),
            content: const Text('Вы действительно хотите удалить свою рекомендацию?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, 'cancel'),
                  child: const Text('Отмена')
              ),
              TextButton(
                  onPressed: () {
                    _delRecommendation(context, recommendation);
                    Navigator.pop(context, 'ok');
                  },
                  child: const Text('Удалить', style: TextStyle(color: Colors.red))
              )
            ]
        )
    );
  }

  void _delRecommendation(BuildContext context, Recommendation recommendation) {
    final store = Provider.of<MainStore>(context, listen: false);
    store.client.socket.emit('recommendation.del', { 'id': recommendation.id }, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data['status'] != 'OK') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Что-то пошло не так во время удаления рекомендации. Попробуйте позже.'), backgroundColor: Colors.red)
        );
        return;
      }
    });
  }
}