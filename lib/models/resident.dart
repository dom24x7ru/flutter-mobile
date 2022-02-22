import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/model.dart';

class Resident extends Model {
  late int personId;
  bool? isOwner;
  bool? deleted;
  Flat? flat;

  Resident(int id, this.personId) : super(id);
  Resident.fromMap(Map<String, dynamic> map) : super(map['id']) {
    personId = map['personId'];
    isOwner = map['isOwner'];
    deleted = map['deleted'];
    if (map['flat'] != null) {
      flat = Flat.fromMap(map['flat']);
    }
  }
}