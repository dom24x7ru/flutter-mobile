import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'miniapp_type.g.dart';

@HiveType(typeId: 28)
class MiniAppType extends Model {
  @HiveField(1)
  late String code;
  @HiveField(2)
  late String name;

  MiniAppType(id, this.code, this.name) : super(id);

  MiniAppType.fromMap(Map<String, dynamic> map) : super(map['id']) {
    code = map['code'];
    name = map['name'];
  }

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'code': code, 'name': name };
  }
}