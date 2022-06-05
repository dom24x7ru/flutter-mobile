import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:dom24x7_flutter/widgets/house_info_card_widget.dart';
import 'package:flutter/material.dart';

import 'flat_page.dart';

class FloorPage extends StatefulWidget {
  final List<Flat> flats;

  const FloorPage(this.flats, {Key? key}) : super(key: key);

  @override
  State<FloorPage> createState() => _FloorPageState();
}

class _FloorPageState extends State<FloorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(context, _getFloorTitle(widget.flats[0])),
      bottomNavigationBar: const Footer(FooterNav.house),
      body: ListView.builder(
        itemCount: widget.flats.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return HouseInfoCard(widget.flats);
          }

          final flat = widget.flats[index - 1];
          final Color color = flat.residents.isNotEmpty ? Colors.black : Colors.black12;

          List<Widget> flatInfo = [
            Text('Квартира №${flat.number}', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: color)),
            Text('Жильцов: ${flat.residents.length}', style: TextStyle(color: color))
          ];
          if (flat.rooms != null) {
            flatInfo.add(
              Text('Комнат: ${flat.rooms}', style: TextStyle(color: color))
            );
          }
          if (flat.square != 0) {
            flatInfo.add(
              Text('Площадь: ${flat.square} кв.м.', style: TextStyle(color: color))
            );
          }

          return GestureDetector(
            onTap: () => { _goFlat(context, flat) },
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: flatInfo
                )
              )
            )
          );
        }
      )
    );
  }

  String _getFloorTitle(Flat flat) {
    if (flat.section != null) {
      String title = 'Подъезд ${flat.section}';
      if (flat.floor != null) {
        title += ' этаж ${flat.floor}';
      } else {
        title += ' этаж не указан';
      }
      return title;
    } else {
      // подъезд не указан, в этом случае и этаж не известен
      return 'Этаж не указан';
    }
  }

  void _goFlat(BuildContext context, Flat flat) {
    if (flat.residents.isEmpty) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(flat)));
  }
}
