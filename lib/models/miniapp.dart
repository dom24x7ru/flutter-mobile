import 'package:dom24x7_flutter/models/model.dart';

class MiniAppType extends Model {
  late String code;
  late String name;

  MiniAppType.fromMap(Map<String, dynamic> map) : super(map['id']) {
    code = map['code'];
    name = map['name'];
  }

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'code': code, 'name': name };
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

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'color': color, 'code': code, 'more': more };
    if (url != null) map['url'] = url;
    return map;
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

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'type': type.toMap(), 'title': title, 'published': published, 'extra': extra.toMap() };
  }
}