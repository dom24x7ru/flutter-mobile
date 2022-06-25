import 'package:hive_flutter/hive_flutter.dart';

part 'level.g.dart';

@HiveType(typeId: 8)
enum Level {
  @HiveField(1)
  nothing,
  @HiveField(2)
  friends,
  @HiveField(3)
  all
}