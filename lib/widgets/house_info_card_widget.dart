import 'package:dom24x7_flutter/models/flat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Card(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Статистика', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Квартир: ${stat.flats}', style: const TextStyle(color: Colors.white60)),
            Text('Заселено: ${stat.flatsWithResidents} (${percent(stat.flatsWithResidents / stat.flats)})', style: const TextStyle(color: Colors.white60)),
            Text('Жильцов: ${stat.residents}', style: const TextStyle(color: Colors.white60)),
            Text('Площадь: ${numberFormat(stat.square)} кв.м. (заселено ${percent(stat.squareResidents / stat.square)})', style: const TextStyle(color: Colors.white60)),
          ],
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

  String numberFormat(double value) {
    var f = NumberFormat('###.00');
    var result = f.format(value);
    return result;
  }

  String percent(double value) {
    var f = NumberFormat('###.00');
    var result = f.format((value * 10000).round() / 100);
    return '$result%';
  }
}