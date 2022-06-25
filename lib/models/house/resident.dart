import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/house/resident_extra.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'resident.g.dart';

@HiveType(typeId: 10)
class Resident extends Model {
  @HiveField(1)
  late int personId;
  @HiveField(2)
  bool? isOwner;
  @HiveField(3)
  bool? deleted;
  @HiveField(4)
  Flat? flat;
  @HiveField(5)
  ResidentExtra? extra;

  Resident(int id, this.personId) : super(id);
  Resident.fromMap(Map<String, dynamic> map) : super(map['id']) {
    personId = map['personId'];
    isOwner = map['isOwner'];
    deleted = map['deleted'];
    if (map['flat'] != null) flat = Flat.fromMap(map['flat']);
    if (map['extra'] != null) extra = ResidentExtra.fromMap(map['extra']);
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'personId': personId };
    if (isOwner != null) map['isOwner'] = isOwner;
    if (deleted != null) map['deleted'] = deleted;
    if (flat != null) map['flat'] = flat!.toMap();
    if (extra != null) map['extra'] = extra!.toMap();
    return map;
  }
}