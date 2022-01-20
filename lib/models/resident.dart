import 'package:dom24x7_flutter/models/flat.dart';

class Resident {
  late int personId;
  bool? isOwner;
  bool? deleted;
  Flat? flat;

  Resident(this.personId);
  Resident.fromMap(Map<String, dynamic> map) {
    personId = map['personId'];
    isOwner = map['isOwner'];
    deleted = map['deleted'];
    if (map['flat'] != null) {
      flat = Flat.fromMap(map['flat']);
    }
  }
}