import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/pages/section_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/house_info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SectionInfo {
  int number; // номер секции
  int floors = 0; // количество этажей
  int flats = 0; // количество квартир
  int flatStart = 1000000; // номер начальной квартиры
  int flatLast = 0; // номер конечной квартиры
  int residents = 0; // количество жильцов
  int flatsWithResidents = 0; // количество заселенных квартир (по регистрациям в приложении)

  SectionInfo(this.number);
}

class HousePage extends StatelessWidget {
  const HousePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    if (!store.loaded) {
      return Scaffold(
        appBar: Header(context, 'Подъезды'),
        bottomNavigationBar: const Footer(FooterNav.house)
      );
    }

    final sections = getSections(store.flats.list);

    return Scaffold(
      appBar: Header(context, 'Подъезды'),
      bottomNavigationBar: const Footer(FooterNav.house),
      body: ListView.builder(
          itemCount: sections.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return HouseInfoCard(store.flats.list!);
            }

            final sectionNumbers = sections.keys.toList();
            final section = sections[sectionNumbers[index - 1]];
            return GestureDetector(
              onTap: () => { goSection(context, store.flats.list!, section!.number) },
              child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Подъезд ${section!.number}', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                        Text('Этажей: ${section.floors}'),
                        Text('Квартиры: ${section.flatStart} - ${section.flatLast}'),
                        Text('Заселено: ${section.flatsWithResidents} (${percent(section.flatsWithResidents / section.flats)})'),
                        Text('Жильцов: ${section.residents}')
                      ]
                    )
                  )
              )
            );
          }
      )
    );
  }

  void goSection(BuildContext context, List<Flat> flats, int sectionNumber) {
    List<Flat> list = [];
    for (var flat in flats) {
      if (flat.section == sectionNumber) {
        list.add(flat);
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => SectionPage(list)));
  }

  Map<int, SectionInfo> getSections(List<Flat>? flats) {
    if (flats == null) return {};

    Map<int, SectionInfo> sections = {};
    for (var flat in flats) {
      if (sections[flat.section] == null) sections[flat.section] = SectionInfo(flat.section);
      var section = sections[flat.section];
      if (section!.floors < flat.floor) section.floors = flat.floor;
      if (section.flatStart > flat.number) section.flatStart = flat.number;
      if (section.flatLast < flat.number) section.flatLast = flat.number;
      if (flat.residents.isNotEmpty) {
        section.flatsWithResidents++;
        section.residents += flat.residents.length;
      }
      section.flats = section.flatLast - section.flatStart + 1;
      sections[flat.section] = section;
    }
    return sections;
  }

  String percent(double value) {
    var f = NumberFormat('###.00');
    var result = f.format((value * 10000).round() / 100);
    return '$result%';
  }
}