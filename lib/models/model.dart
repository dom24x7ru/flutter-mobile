import 'package:hive_flutter/hive_flutter.dart';

part 'model.g.dart';

@HiveType(typeId: 1)
abstract class Model {
  @HiveField(0)
  late int id;
  Model(this.id);

  Map<String, dynamic> toMap();
}