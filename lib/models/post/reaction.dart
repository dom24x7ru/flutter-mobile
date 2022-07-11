import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/models/user/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'reaction.g.dart';

@HiveType(typeId: 41)
class Reaction extends Model {
  @HiveField(1)
  IMPerson? user;
  @HiveField(2)
  Map<String, dynamic>? data;

  Reaction(int id) : super(id);
  
  Reaction.fromMap(Map<String, dynamic> map) : super(map['id']) {
    if (map['user'] != null) user = IMPerson.fromMap(map['user']);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}