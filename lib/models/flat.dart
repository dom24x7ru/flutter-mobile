import 'package:dom24x7_flutter/models/resident.dart';

class Flat {
  late int number;
  late int floor;
  late int section;
  int? rooms;
  num? square;
  List<Resident> residents = [];

  Flat(this.number, this.floor, this.section);
  Flat.fromMap(Map<String, dynamic> map) {
    number = map['number'];
    floor = map['floor'];
    section = map['section'];
    rooms = map['rooms'];
    square = map['square'];
    if (map['residents'] != null) {
      for (var item in map['residents']) {
        residents.add(Resident.fromMap(item));
      }
    }
  }
}