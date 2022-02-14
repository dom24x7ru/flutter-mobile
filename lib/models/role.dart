import 'package:dom24x7_flutter/models/model.dart';

class Role extends Model {
  late String name;

  Role(id, this.name) : super(id);
  Role.fromMap(Map<String, dynamic> map) : super(map['id']) {
    name = map['name'];
  }
}