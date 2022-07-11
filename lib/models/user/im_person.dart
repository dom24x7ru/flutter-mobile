import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'im_person.g.dart';

@HiveType(typeId: 21)
class IMPerson {
  @HiveField(1)
  late Person person;
  @HiveField(2)
  Flat? flat;
  @HiveField(3)
  String? profilePhotoThumbnail;
  @HiveField(4)
  String? profilePhotoResized;

  IMPerson(this.person, this.flat, this.profilePhotoThumbnail, this.profilePhotoResized);

  IMPerson.fromMap(Map<String, dynamic> map) {
    person = Person.fromMap(map);
    if (map['flat'] != null) flat = Flat.fromMap(map['flat']);
    if (map['profilePhoto'] != null) {
      profilePhotoThumbnail = map['profilePhoto']['thumbnail'];
      profilePhotoResized = map['profilePhoto']['resized'];
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'person': person.toMap() };
    if (flat != null) map['flat'] = flat!.toMap();
    map['profilePhotoThumbnail'] = profilePhotoThumbnail;
    map['profilePhotoResized'] = profilePhotoResized;
    return map;
  }
}