import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/person.dart';

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

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id };
    if (createdAt != null) map['createdAt'] = createdAt;
    if (code != null) map['code'] = code;
    if (used != null) map['used'] = used;
    if (person != null) map['person'] = person!.toMap();
    if (flat != null) map['flat'] = flat!.toMap();
    return map;
  }
}