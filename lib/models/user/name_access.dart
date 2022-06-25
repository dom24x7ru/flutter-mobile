import 'package:dom24x7_flutter/models/user/enums/level.dart';
import 'package:dom24x7_flutter/models/user/enums/name_format.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'name_access.g.dart';

@HiveType(typeId: 6)
class NameAccess {
  @HiveField(1)
  Level level = Level.nothing;
  @HiveField(2)
  NameFormat format = NameFormat.all;

  NameAccess(this.level, this.format);
  NameAccess.fromMap(Map<String, dynamic> map) {
    switch(map['level']) {
      case 'nothing':
        level = Level.nothing;
        break;
      case 'friends':
        level = Level.friends;
        break;
      case 'all':
        level = Level.all;
        break;
    }
    switch(map['format']) {
      case 'name':
        format = NameFormat.name;
        break;
      case 'all':
        format = NameFormat.all;
        break;
    }
  }

  Map<String, dynamic> toMap() {
    return { 'level': level.name, 'format': format.name };
  }
}