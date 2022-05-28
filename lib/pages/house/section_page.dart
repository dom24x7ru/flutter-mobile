import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/pages/house/floor_page.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/house_info_card_widget.dart';
import 'package:flutter/material.dart';

class FloorInfo {
  String title; // название этажа
  int? number; // номер этажа
  int flats = 0; // количество квартир
  int flatStart = 1000000; // номер начальной квартиры
  int flatLast = 0; // номер конечной квартиры
  int residents = 0; // количество жильцов
  int flatsWithResidents = 0; // количество заселенных квартир (по регистрациям в приложении)

  FloorInfo(this.title);
}

class SectionPage extends StatefulWidget {
  final List<Flat> flats;

  const SectionPage(this.flats, {Key? key}) : super(key: key);

  @override
  _SectionPageState createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  @override
  Widget build(BuildContext context) {
    final floors = _getFloors(widget.flats);

    return Scaffold(
      appBar: Header(context, _getSectionTitle(widget.flats[0])),
      bottomNavigationBar: const Footer(FooterNav.house),
      body: ListView.builder(
        itemCount: floors.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return HouseInfoCard(widget.flats);
          }

          var floorsList = floors.values.toList();
          floorsList.sort((floor1, floor2) {
            final int number1 = floor1.number != null ? floor1.number! : -1000;
            final int number2 = floor2.number != null ? floor2.number! : -1000;
            if (number1 > number2) return 1;
            if (number1 < number2) return -1;
            return 0;
          });
          final floor = floorsList[index - 1];
          return GestureDetector(
            onTap: () => { _goFloor(context, widget.flats, widget.flats[0].section, floor) },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(floor.title, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Text('Квартиры: ${floor.flatStart} - ${floor.flatLast}'),
                    Text('Заселено: ${floor.flatsWithResidents} (${Utilities.percent(floor.flatsWithResidents / floor.flats)})'),
                    Text('Жильцов: ${floor.residents}')
                  ]
                )
              )
            )
          );
        },
      )
    );
  }

  String _getSectionTitle(Flat flat) {
    return flat.section != null ? 'Подъезд ${flat.section}' : 'Подъезд не указан';
  }

  void _goFloor(BuildContext context, List<Flat> flats, int? sectionNumber, FloorInfo floor) {
    List<Flat> list = [];
    for (var flat in flats) {
      if (flat.section == sectionNumber && flat.floor == floor.number) {
        list.add(flat);
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => FloorPage(list)));
  }

  Map<String, FloorInfo> _getFloors(List<Flat>? flats) {
    if (flats == null) return {};

    Map<String, FloorInfo> floors = {};
    for (var flat in flats) {
      String title = flat.floor != null ? 'Этаж ${flat.floor}' : 'Этаж не указан';
      if (floors[title] == null) floors[title] = FloorInfo(title);
      var floor = floors[title];
      floor?.number = flat.floor;
      if (floor!.flatStart > flat.number) floor.flatStart = flat.number;
      if (floor.flatLast < flat.number) floor.flatLast = flat.number;
      if (flat.residents.isNotEmpty) {
        floor.flatsWithResidents++;
        floor.residents += flat.residents.length;
      }
      floor.flats = floor.flatLast - floor.flatStart + 1;
      floors[title] = floor;
    }
    return floors;
  }
}
