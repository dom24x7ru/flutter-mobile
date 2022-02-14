import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/models/resident.dart';
import 'package:dom24x7_flutter/models/role.dart';

class User extends Model {
  late String mobile;
  late bool banned;
  late Role role;
  int? houseId;
  Person? person;
  Resident? resident;

  User(id, this.mobile, this.banned, this.role) : super(id);
  User.fromMap(Map<String, dynamic> map) : super(map['id']) {
    mobile = map['mobile'];
    banned = map['banned'];
    role = Role.fromMap(map['role']);
    houseId = map['houseId'];
    person = map['person'] != null ? Person.fromMap(map['person']) : null;
    resident = map['resident'] != null ? Resident.fromMap(map['resident']) : null;
  }
}