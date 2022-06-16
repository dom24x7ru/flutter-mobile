import 'package:dom24x7_flutter/models/model.dart';

class MiniAppType extends Model {
  late String code;
  late String name;

  MiniAppType.fromMap(Map<String, dynamic> map) : super(map['id']) {
    code = map['code'];
    name = map['name'];
  }
}

class MiniAppExtra {
  late String color;
  late String code;
  String? url;
  late Map<String, dynamic> more;

  MiniAppExtra.fromMap(Map<String, dynamic> map) {
    color = map['color'];
    code = map['code'];
    if (map['url'] != null) url = map['url'];
    more = map;
  }
}

class MiniApp extends Model {
  late MiniAppType type;
  late String title;
  late bool published;
  late MiniAppExtra extra;

  MiniApp.fromMap(Map<String, dynamic> map) : super(map['id']) {
    type = MiniAppType.fromMap(map['type']);
    title = map['title'];
    published = map['published'];
    extra =MiniAppExtra.fromMap(map['extra']);
  }
}