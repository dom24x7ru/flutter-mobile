import 'package:dom24x7_flutter/models/house/tenant.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'resident_extra.g.dart';

@HiveType(typeId: 11)
class ResidentExtra {
  @HiveField(1)
  late String type;
  @HiveField(2)
  Tenant? tenant;

  ResidentExtra(this.type);
  ResidentExtra.fromMap(Map<String, dynamic> map) {
    type = map['type'];
    if (map['tenant'] != null) tenant = Tenant.fromMap(map['tenant']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'type': type };
    if (tenant != null) map['tenant'] = tenant!.toMap();
    return map;
  }
}