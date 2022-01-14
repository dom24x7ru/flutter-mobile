import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/house_info_card_widget.dart';
import 'package:flutter/material.dart';

import 'flat_page.dart';

class FloorPage extends StatefulWidget {
  final List<Flat> flats;

  const FloorPage(this.flats, {Key? key}) : super(key: key);

  @override
  _FloorPageState createState() => _FloorPageState();
}

class _FloorPageState extends State<FloorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(context, 'Подъезд ${widget.flats[0].section} этаж ${widget.flats[0].floor}'),
      bottomNavigationBar: Footer(context, FooterNav.house),
      body: ListView.builder(
        itemCount: widget.flats.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return HouseInfoCard(widget.flats);
          }

          final flat = widget.flats[index - 1];
          final Color color = flat.residents.isNotEmpty ? Colors.black : Colors.black12;
          return GestureDetector(
            onTap: () => { goFlat(context, flat) },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Квартира №${flat.number}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: color)),
                    Text('Жильцов: ${flat.residents.length}', style: TextStyle(color: color)),
                    Text('Комнат: ${flat.rooms}', style: TextStyle(color: color)),
                    Text('Площадь: ${flat.square} кв.м.', style: TextStyle(color: color))
                  ]
                )
              )
            )
          );
        }
      )
    );
  }

  void goFlat(BuildContext context, Flat flat) {
    if (flat.residents.isEmpty) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(flat)));
  }
}
