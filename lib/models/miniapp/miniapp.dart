import 'package:dom24x7_flutter/models/miniapp/miniapp_extra.dart';
import 'package:dom24x7_flutter/models/miniapp/miniapp_type.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'miniapp.g.dart';

@HiveType(typeId: 26)
class MiniApp extends Model {
  @HiveField(1)
  late MiniAppType type;
  @HiveField(2)
  late String title;
  @HiveField(3)
  late bool published;
  @HiveField(4)
  late MiniAppExtra extra;

  MiniApp(id, this.type, this.title, this.published, this.extra) : super(id);

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