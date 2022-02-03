import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/models/recommendation.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../flat_page.dart';

class RecommendationsListPage extends StatelessWidget {
  final List<Recommendation> list;
  const RecommendationsListPage(this.list, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final categoryName = list.isNotEmpty ? list[0].category.name : null;

    return Scaffold(
        appBar: Header(context, categoryName != null ? getHeaderTitle(categoryName) : 'Неизвестная категория'),
        bottomNavigationBar: Footer(context, FooterNav.services),
        body: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final recommendation = list[index];
              final extra = recommendation.extra;
              List<Widget> infoList = [
                Text(recommendation.title, style: const TextStyle(fontSize: 18.0)),
                Row(children: [
                  const Text('Автор: '),
                  InkWell(
                      child: Text(getAuthorName(recommendation), style: const TextStyle(color: Colors.blue)),
                      onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(getFlat(store, recommendation)))) })
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
                    onTap: () => { launch('tel:${extra.phone}') }
                  )
                ]));
              }
              if (extra.instagram != null) {
                infoList.add(Row(children: [
                  const FaIcon(FontAwesomeIcons.instagram),
                  InkWell(
                    child: Text(' ${extra.instagram!}', style: const TextStyle(color: Colors.blue)),
                    onTap: () => { launch('https://www.instagram.com/${extra.instagram}/') }
                  )
                ]));
              }
              if (extra.telegram != null) {
                infoList.add(Row(children: [
                  const FaIcon(FontAwesomeIcons.telegramPlane),
                  InkWell(
                    child: Text(' ${extra.telegram!}', style: const TextStyle(color: Colors.blue)),
                    onTap: () => { launch('https://t.me/${extra.telegram}') }
                  )
                ]));
              }
              if (extra.site != null) {
                infoList.add(Row(children: [
                  const Icon(Icons.language),
                  InkWell(
                    child: Text(extra.site!, style: const TextStyle(color: Colors.blue)),
                    onTap: () => { launch('https://${extra.site}') }
                  )
                ]));
                if (extra.email != null) {
                  infoList.add(Row(children: [
                    const Icon(Icons.alternate_email),
                    InkWell(
                      child: Text(extra.email!, style: const TextStyle(color: Colors.blue)),
                      onTap: () => { launch('mailto:${extra.email}') }
                    )
                  ]));
                }
              }
              infoList.add(const Divider());
              infoList.add(Text(recommendation.body));

              return Card(
                  child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: infoList)));
            }));
  }

  String getHeaderTitle(String title) {
    if (title.length < 20) return title;
    return title.substring(0, 20) + '...';
  }

  String getAuthorName(Recommendation recommendation) {
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
    if (fullName.isEmpty) {
      final flat = recommendation.flat;
      return 'сосед(ка) из кв. №${flat.number}, этаж ${flat.floor}, подъезд ${flat.section}';
    }
    return fullName;
  }

  Flat getFlat(MainStore store, Recommendation recommendation) {
    Flat flat = recommendation.flat;
    final flats = store.flats.list!;
    for (Flat item in flats) {
      if (item.id == flat.id) return item;
    }
    return flat;
  }
}
