import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';

class Stat {
  late int flats; // количество квартир
  late int flatsWithResidents; // количество заселенный квартир
  late int residents; // количество жильцов
  late double square; // общая площадь
  late double squareResidents; // площадь заселенных квартир
}

class HouseInfoCard extends StatefulWidget {
  final List<Flat> flats;

  const HouseInfoCard(this.flats, {Key? key}) : super(key: key);

  @override
  State<HouseInfoCard> createState() => _HouseInfoCardState();
}

class _HouseInfoCardState extends State<HouseInfoCard> {
  @override
  Widget build(BuildContext context) {
    var stat = getStat();
    List<Widget> infoList = [
      const Text('Статистика', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
      Text('Квартир: ${stat.flats}', style: const TextStyle(color: Colors.white60)),
      Text('Заселено: ${stat.flatsWithResidents} (${Utilities.percent(stat.flatsWithResidents / stat.flats)})', style: const TextStyle(color: Colors.white60)),
      Text('Жильцов: ${stat.residents}', style: const TextStyle(color: Colors.white60))
    ];
    if (stat.square != 0) {
      infoList.add(
        Text('Площадь: ${Utilities.numberFormat(stat.square)} кв.м. (заселено ${Utilities.percent(stat.squareResidents / stat.square)})', style: const TextStyle(color: Colors.white60))
      );
    }
    return Card(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: infoList
        ),
      )
    );
  }

  Stat getStat() {
    Stat stat = Stat();
    stat.flats = widget.flats.length;

    stat.flatsWithResidents = 0;
    stat.residents = 0;
    stat.square = 0.0;
    stat.squareResidents = 0.0;
    for (var flat in widget.flats) {
      stat.square += flat.square;
      if (flat.residents.isNotEmpty) {
        stat.flatsWithResidents++;
        stat.residents += flat.residents.length;
        stat.squareResidents += flat.square;
      }
    }

    return stat;
  }
}
