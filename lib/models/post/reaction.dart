import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'reaction.g.dart';

@HiveType(typeId: 41)
class Reaction extends Model {
  @HiveField(1)
  User? user;
  @HiveField(2)
  Map<String, dynamic>? data;

  Reaction(int id) : super(id);

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}