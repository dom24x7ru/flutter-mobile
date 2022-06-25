import 'package:dom24x7_flutter/models/user/enums/level.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'contact_access.g.dart';

@HiveType(typeId: 7)
class ContactAccess {
  @HiveField(1)
  Level level = Level.nothing;

  ContactAccess(this.level);
  ContactAccess.fromMap(Map<String, dynamic> map) {
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
  }

  Map<String, dynamic> toMap() {
    return { 'level': level.name };
  }
}