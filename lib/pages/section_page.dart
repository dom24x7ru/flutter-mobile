import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/pages/floor_page.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/house_info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FloorInfo {
  int number; // номер этажа
  int flats = 0; // количество квартир
  int flatStart = 1000000; // номер начальной квартиры
  int flatLast = 0; // номер конечной квартиры
  int residents = 0; // количество жильцов
  int flatsWithResidents = 0; // количество заселенных квартир (по регистрациям в приложении)

  FloorInfo(this.number);
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
    final floors = getFloors(widget.flats);

    return Scaffold(
      appBar: Header(context, 'Подъезд ${widget.flats[0].section}'),
      bottomNavigationBar: const Footer(FooterNav.house),
      body: ListView.builder(
        itemCount: floors.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return HouseInfoCard(widget.flats);
          }

          final floorNumbers = floors.keys.toList();
          final floor = floors[floorNumbers[index - 1]];
          return GestureDetector(
            onTap: () => { goFloor(context, widget.flats, widget.flats[0].section, floor!.number) },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Этаж ${floor!.number}', style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Text('Квартиры: ${floor.flatStart} - ${floor.flatLast}'),
                    Text('Заселено: ${floor.flatsWithResidents} (${percent(floor.flatsWithResidents / floor.flats)})'),
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

  void goFloor(BuildContext context, List<Flat> flats, int sectionNumber, int floorNumber) {
    List<Flat> list = [];
    for (var flat in flats) {
      if (flat.section == sectionNumber && flat.floor == floorNumber) {
        list.add(flat);
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => FloorPage(list)));
  }

  Map<int, FloorInfo> getFloors(List<Flat>? flats) {
    if (flats == null) return {};

    Map<int, FloorInfo> floors = {};
    for (var flat in flats) {
      if (floors[flat.floor] == null) floors[flat.floor] = FloorInfo(flat.floor);
      var floor = floors[flat.floor];
      if (floor!.flatStart > flat.number) floor.flatStart = flat.number;
      if (floor.flatLast < flat.number) floor.flatLast = flat.number;
      if (flat.residents.isNotEmpty) {
        floor.flatsWithResidents++;
        floor.residents += flat.residents.length;
      }
      floor.flats = floor.flatLast - floor.flatStart + 1;
      floors[flat.floor] = floor;
    }
    return floors;
  }

  String percent(double value) {
    var f = NumberFormat('###.00');
    var result = f.format((value * 10000).round() / 100);
    return '$result%';
  }
}
