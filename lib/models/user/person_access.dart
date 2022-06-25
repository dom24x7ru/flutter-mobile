import 'package:dom24x7_flutter/models/user/contact_access.dart';
import 'package:dom24x7_flutter/models/user/name_access.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'person_access.g.dart';

@HiveType(typeId: 5)
class PersonAccess {
  @HiveField(1)
  NameAccess? name;
  @HiveField(2)
  ContactAccess? mobile;
  @HiveField(3)
  ContactAccess? telegram;

  PersonAccess(this.name, this.mobile, this.telegram);
  PersonAccess.fromMap(Map<String, dynamic> map) {
    name = NameAccess.fromMap(map['name']);
    mobile = ContactAccess.fromMap(map['mobile']);
    telegram = ContactAccess.fromMap(map['telegram']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (name != null) map['name'] = name!.toMap();
    if (mobile != null) map['mobile'] = mobile!.toMap();
    if (telegram != null) map['telegram'] = telegram!.toMap();
    return map;
  }
}