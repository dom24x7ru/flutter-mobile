import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/person_access.dart';
import 'package:dom24x7_flutter/models/resident.dart';

class Person extends Model {
  String? surname;
  String? name;
  String? midname;
  DateTime? birthday;
  String? sex;
  String? biography;
  String? telegram;
  String? mobile;
  bool deleted = false;
  PersonAccess? access;
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