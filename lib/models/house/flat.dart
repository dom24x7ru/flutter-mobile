import 'package:dom24x7_flutter/models/house/flat_type.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/house/resident.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'flat.g.dart';

@HiveType(typeId: 13)
class Flat extends Model {
  @HiveField(1)
  late int number;
  @HiveField(2)
  int? floor;
  @HiveField(3)
  int? section;
  @HiveField(4)
  int? rooms;
  @HiveField(5)
  double square = 0;
  @HiveField(6)
  FlatType? type;
  @HiveField(7)
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

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'number': number, 'floor': floor, 'section': section };
    if (rooms != null) map['rooms'] = rooms;
    if (square != 0) map['square'] = square;
    if (type != null) map['type'] = type!.toMap();
    map['residents'] = [];
    for (var resident in residents) {
      map['residents'].add(resident.toMap());
    }
    return map;
  }
}