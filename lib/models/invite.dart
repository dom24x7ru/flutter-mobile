import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/person.dart';

class Invite {
  late int id;
  int? createdAt;
  String? code;
  bool? used;
  Person? person;
  Flat? flat;

  Invite(this.id);
  Invite.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    createdAt = map['createdAt'];
    code = map['code'];
    used = map['used'];
    if (map['person'] != null) person = Person.fromMap(map['person']);
    if (map['flat'] != null) flat = Flat.fromMap(map['flat']);
  }
}