import 'package:hive_flutter/hive_flutter.dart';

part 'miniapp_extra.g.dart';

@HiveType(typeId: 27)
class MiniAppExtra {
  @HiveField(1)
  late String color;
  @HiveField(2)
  late String code;
  @HiveField(3)
  String? url;
  @HiveField(4)
  late Map<String, dynamic> more;

  MiniAppExtra(this.color, this.code, this.url, this.more);

  MiniAppExtra.fromMap(Map<String, dynamic> map) {
    color = map['color'];
    code = map['code'];
    if (map['url'] != null) url = map['url'];
    more = map;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'color': color, 'code': code, 'more': more };
    if (url != null) map['url'] = url;
    return map;
  }
}