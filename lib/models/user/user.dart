import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:dom24x7_flutter/models/house/resident.dart';
import 'package:dom24x7_flutter/models/user/role.dart';

class User extends Model {
  late String mobile;
  late bool banned;
  late Role role;
  int? houseId;
  Person? person;
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
}