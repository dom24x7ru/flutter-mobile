import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'role.g.dart';

@HiveType(typeId: 3)
class Role extends Model {
  @HiveField(1)
  late String name;

  Role(id, this.name) : super(id);
  Role.fromMap(Map<String, dynamic> map) : super(map['id']) {
    name = map['name'];
  }

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'name': name };
  }
}