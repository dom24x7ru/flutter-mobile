import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'im_person.g.dart';

@HiveType(typeId: 21)
class IMPerson {
  @HiveField(1)
  final Person person;
  @HiveField(2)
  final Flat flat;

  IMPerson(this.person, this.flat);

  Map<String, dynamic> toMap() {
    return { 'person': person.toMap(), 'flat': flat.toMap() };
  }
}