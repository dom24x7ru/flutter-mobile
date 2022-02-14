import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/resident.dart';

class Flat extends Model {
  late int number;
  late int floor;
  late int section;
  int? rooms;
  double square = 0;
  List<Resident> residents = [];

  Flat(id, this.number, this.floor, this.section) : super(id);
  Flat.fromMap(Map<String, dynamic> map) : super(map['id']) {
    number = map['number'];
    floor = map['floor'];
    section = map['section'];
    rooms = map['rooms'];
    if (map['square'] != null) {
      square = map['square'].toDouble();
    }
    if (map['residents'] != null) {
      for (var item in map['residents']) {
        residents.add(Resident.fromMap(item));
      }
    }
  }
}