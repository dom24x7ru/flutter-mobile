import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:dom24x7_flutter/models/house/resident.dart';
import 'package:dom24x7_flutter/models/user/role.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User extends Model {
  @HiveField(1)
  late String mobile;
  @HiveField(2)
  late bool banned;
  @HiveField(3)
  late Role role;
  @HiveField(4)
  int? houseId;
  @HiveField(5)
  Person? person;
  @HiveField(6)
  List<Resident> residents = [];

  User(id, this.mobile, this.banned, this.role) : super(id);
  User.fromMap(Map<String, dynamic> map) : super(map['id']) {
    mobile = map['mobile'];
    banned = map['banned'];
    role = Role.fromMap(map['role']);
    houseId = map['houseId'];
    person = map['person'] != null ? Person.fromMap(map['person']) : null;
    if (map['residents'] != null) {
      for (var resident in map['residents']) {
        residents.add(Resident.fromMap(resident));
      }
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'mobile': mobile, 'banned': banned, 'role': role.toMap() };
    if (houseId != null) map['houseId'] = houseId;
    if (person != null) map['person'] = person!.toMap();
    map['residents'] = [];
    for (var resident in residents) {
      map['residents'].add(resident.toMap());
    }
    return map;
  }

  IMPerson toIMPerson() {
    return IMPerson(person!, residents[0].flat, null, null);
  }
}