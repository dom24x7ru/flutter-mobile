import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/person.dart';

class Invite extends Model {
  int? createdAt;
  String? code;
  bool? used;
  Person? person;
  Flat? flat;

  Invite(id) : super(id);
  Invite.fromMap(Map<String, dynamic> map) : super(map['id']) {
    createdAt = map['createdAt'];
    code = map['code'];
    used = map['used'];
    if (map['person'] != null) person = Person.fromMap(map['person']);
    if (map['flat'] != null) flat = Flat.fromMap(map['flat']);
  }
}