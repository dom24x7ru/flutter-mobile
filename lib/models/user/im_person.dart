import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'im_person.g.dart';

@HiveType(typeId: 21)
class IMPerson {
  @HiveField(1)
  final Person person;
  @HiveField(2)
  final Flat? flat;
  @HiveField(3)
  final String? profilePhotoThumbnail;
  @HiveField(4)
  final String? profilePhotoResized;

  IMPerson(this.person, this.flat, this.profilePhotoThumbnail, this.profilePhotoResized);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'person': person.toMap() };
    if (flat != null) map['flat'] = flat!.toMap();
    map['profilePhotoThumbnail'] = profilePhotoThumbnail;
    map['profilePhotoResized'] = profilePhotoResized;
    return map;
  }
}