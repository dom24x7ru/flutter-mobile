import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/model.dart';

class Tenant {
  late int start;
  int? end;

  Tenant(this.start, this.end);
  Tenant.fromMap(Map<String, dynamic> map) {
    start = map['start'];
    end = map['end'];
  }

  Map<String, dynamic> toMap() {
    return { 'start': start, 'end': end };
  }
}

class ResidentExtra {
  late String type;
  Tenant? tenant;

  ResidentExtra(this.type);
  ResidentExtra.fromMap(Map<String, dynamic> map) {
    type = map['type'];
    if (map['tenant'] != null) tenant = Tenant.fromMap(map['tenant']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'type': type };
    if (tenant != null) map['tenant'] = tenant!.toMap();
    return map;
  }
}

class Resident extends Model {
  late int personId;
  bool? isOwner;
  bool? deleted;
  Flat? flat;
  ResidentExtra? extra;

  Resident(int id, this.personId) : super(id);
  Resident.fromMap(Map<String, dynamic> map) : super(map['id']) {
    personId = map['personId'];
    isOwner = map['isOwner'];
    deleted = map['deleted'];
    if (map['flat'] != null) flat = Flat.fromMap(map['flat']);
    if (map['extra'] != null) extra = ResidentExtra.fromMap(map['extra']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'personId': personId };
    if (isOwner != null) map['isOwner'] = isOwner;
    if (deleted != null) map['deleted'] = deleted;
    if (flat != null) map['flat'] = flat!.toMap();
    if (extra != null) map['extra'] = extra!.toMap();
    return map;
  }
}