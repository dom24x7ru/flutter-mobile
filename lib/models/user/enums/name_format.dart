import 'package:hive_flutter/hive_flutter.dart';

part 'name_format.g.dart';

@HiveType(typeId: 9)
enum NameFormat {
  @HiveField(1)
  name,
  @HiveField(2)
  all
}