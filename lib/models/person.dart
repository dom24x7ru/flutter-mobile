import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/person_access.dart';

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
    if (map['access'] != null) {
      access = PersonAccess.fromMap(map['access']);
    }
  }
}