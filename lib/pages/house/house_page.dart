import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/pages/house/section_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/house_info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SectionInfo {
  String title; // название секции
  int? number; // номер секции
  int floors = 0; // количество этажей
  int flats = 0; // количество квартир
  int flatStart = 1000000; // номер начальной квартиры
  int flatLast = 0; // номер конечной квартиры
  int residents = 0; // количество жильцов
  int flatsWithResidents = 0; // количество заселенных квартир (по регистрациям в приложении)

  SectionInfo(this.title);
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

    final sections = _getSections(store.flats.list);

    return Scaffold(
      appBar: Header(context, 'Подъезды'),
      bottomNavigationBar: const Footer(FooterNav.house),
      body: ListView.builder(
          itemCount: sections.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return HouseInfoCard(store.flats.list!);
            }

            var sectionsList = sections.values.toList();
            sectionsList.sort((section1, section2) {
              final int number1 = section1.number != null ? section1.number! : -1000;
              final int number2 = section2.number != null ? section2.number! : -1000;
              if (number1 > number2) return 1;
              if (number1 < number2) return -1;
              return 0;
            });
            final section = sectionsList[index - 1];

            List<Widget> sectionInfo = [
              Text(section.title, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              Text('Квартиры: ${section.flatStart} - ${section.flatLast}'),
              Text('Заселено: ${section.flatsWithResidents} (${Utilities.percent(section.flatsWithResidents / section.flats)})'),
              Text('Жильцов: ${section.residents}')
            ];
            if (section.floors != 0) {
              sectionInfo.insert(1, Text('Этажей: ${section.floors}'));
            }

            return GestureDetector(
              onTap: () => _goSection(context, store.flats.list!, section),
              child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: sectionInfo
                    )
                  )
              )
            );
          }
      )
    );
  }

  void _goSection(BuildContext context, List<Flat> flats, SectionInfo section) {
    List<Flat> list = [];
    for (var flat in flats) {
      if (flat.section == section.number) {
        list.add(flat);
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => SectionPage(list)));
  }

  /// Формируем структуру данных для отображения карточек подъездов
  Map<String, SectionInfo> _getSections(List<Flat>? flats) {
    if (flats == null) return {};

    Map<String, SectionInfo> sections = {};
    for (var flat in flats) {
      String title = flat.section != null ? 'Подъезд ${flat.section}' : 'Подъезд не указан';
      if (sections[title] == null) sections[title] = SectionInfo(title);
      var section = sections[title]!;
      section.number = flat.section;
      if (flat.floor != null && section.floors < flat.floor!) section.floors = flat.floor!;
      if (section.flatStart > flat.number) section.flatStart = flat.number;
      if (section.flatLast < flat.number) section.flatLast = flat.number;
      if (flat.residents.isNotEmpty) {
        section.flatsWithResidents++;
        section.residents += flat.residents.length;
      }
      section.flats = section.flatLast - section.flatStart + 1;
      sections[title] = section;
    }
    return sections;
  }
}