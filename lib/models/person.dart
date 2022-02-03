import 'package:dom24x7_flutter/models/person_access.dart';

class Person {
  int? id;
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

  Person(this.id, this.surname, this.name, this.midname);
  Person.fromMap(Map<String, dynamic> map) {
    id = map['id'];
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
    if (map['access'] != null) {
      access = PersonAccess.fromMap(map['access']);
    }
  }
}