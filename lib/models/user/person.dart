import 'package:dom24x7_flutter/models/house/resident_extra.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/person_access.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'person.g.dart';

@HiveType(typeId: 4)
class Person extends Model {
  @HiveField(1)
  String? surname;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? midname;
  @HiveField(4)
  DateTime? birthday;
  @HiveField(5)
  String? sex;
  @HiveField(6)
  String? biography;
  @HiveField(7)
  String? telegram;
  @HiveField(8)
  String? mobile;
  @HiveField(9)
  bool deleted = false;
  @HiveField(10)
  PersonAccess? access;
  @HiveField(11)
  ResidentExtra? extra;

  Person(id, this.surname, this.name, this.midname) : super(id);
  Person.fromMap(Map<String, dynamic> map) : super(map['id']) {
    surname = map['surname'];
    name = map['name'];
    midname = map['midname'];
    telegram = map['telegram'];
    mobile = map['mobile'];
    if (map['deleted'] != null) {
      deleted = map['deleted'];
    } else {
      deleted = false;
    }
    if (map['access'] != null) access = PersonAccess.fromMap(map['access']);
    if (map['extra'] != null) extra = ResidentExtra.fromMap(map['extra']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id };
    if (surname != null) map['surname'] = surname;
    if (name != null) map['name'] = name;
    if (midname != null) map['midname'] = midname;
    if (birthday != null) map['birthday'] = birthday;
    if (sex != null) map['sex'] = sex;
    if (biography != null) map['biography'] = biography;
    if (telegram != null) map['telegram'] = telegram;
    if (mobile != null) map['mobile'] = mobile;
    map['deleted'] = deleted;
    if (access != null) map['access'] = access!.toMap();
    if (extra != null) map['extra'] = extra!.toMap();
    return map;
  }
}