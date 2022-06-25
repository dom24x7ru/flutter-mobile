import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'flat_type.g.dart';

@HiveType(typeId: 14)
class FlatType extends Model {
  @HiveField(1)
  late String code;
  @HiveField(2)
  late String name;

  FlatType(id, this.code, this.name) : super(id);
  FlatType.fromMap(Map<String, dynamic> map) : super(map['id']) {
    code = map['code'];
    name = map['name'];
  }

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'code': code, 'name': name };
  }
}