import 'package:hive_flutter/hive_flutter.dart';

part 'tenant.g.dart';

@HiveType(typeId: 12)
class Tenant {
  @HiveField(1)
  late int start;
  @HiveField(2)
  int? end;

  Tenant(this.start, this.end);
  Tenant.fromMap(Map<String, dynamic> map) {
    start = map['start'];
    end = map['end'];
  }

  Map<String, dynamic> toMap() {
    return { 'start': start, 'end': end };
  }
}