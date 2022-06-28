import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'invite.g.dart';

@HiveType(typeId: 29)
class Invite extends Model {
  @HiveField(1)
  late int createdAt;
  @HiveField(2)
  late int updatedAt;
  @HiveField(3)
  String? code;
  @HiveField(4)
  bool? used;
  @HiveField(5)
  Person? person;
  @HiveField(6)
  Flat? flat;

  Invite(id, this.createdAt, this.updatedAt, this.code, this.used, this.person, this.flat) : super(id);

  Invite.fromMap(Map<String, dynamic> map) : super(map['id']) {
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    code = map['code'];
    used = map['used'];
    if (map['person'] != null) person = Person.fromMap(map['person']);
    if (map['flat'] != null) flat = Flat.fromMap(map['flat']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'createdAt': createdAt, 'updatedAt': updatedAt };
    if (code != null) map['code'] = code;
    if (used != null) map['used'] = used;
    if (person != null) map['person'] = person!.toMap();
    if (flat != null) map['flat'] = flat!.toMap();
    return map;
  }
}