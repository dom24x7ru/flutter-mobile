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

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'personId': personId };
    if (isOwner != null) map['isOwner'] = isOwner;
    if (deleted != null) map['deleted'] = deleted;
    if (flat != null) map['flat'] = flat!.toMap();
    return map;
  }
}