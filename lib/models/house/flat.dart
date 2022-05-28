import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/house/resident.dart';

class FlatType extends Model {
  late String code;
  late String name;

  FlatType(id, this.code, this.name) : super(id);
  FlatType.fromMap(Map<String, dynamic> map) : super(map['id']) {
    code = map['code'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    return { 'id': id, 'code': code, 'name': name };
  }
}

class Flat extends Model {
  late int number;
  int? floor;
  int? section;
  int? rooms;
  double square = 0;
  FlatType? type;
  List<Resident> residents = [];

  Flat(id, this.number, this.floor, this.section) : super(id);
  Flat.fromMap(Map<String, dynamic> map) : super(map['id']) {
    number = map['number'];
    floor = map['floor'];
    section = map['section'];
    rooms = map['rooms'];
    if (map['square'] != null) square = map['square'].toDouble();
    if (map['type'] != null) type = FlatType.fromMap(map['type']);
    if (map['residents'] != null) {
      for (var item in map['residents']) {
        residents.add(Resident.fromMap(item));
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'number': number, 'floor': floor, 'section': section };
    if (rooms != null) map['rooms'] = rooms;
    if (square != 0) map['square'] = square;
    if (type != null) map['type'] = type!.toMap();
    map['residents'] = [];
    for (var resident in residents) {
      map['residents'].app(resident.toMap());
    }
    return map;
  }
}