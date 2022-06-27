import 'package:hive_flutter/hive_flutter.dart';

abstract class Model {
  @HiveField(0)
  late int id;
  Model(this.id);

  Map<String, dynamic> toMap();
}