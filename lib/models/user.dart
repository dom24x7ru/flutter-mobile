import 'package:dom24x7_flutter/models/role.dart';

class User {
  int id;
  String mobile;
  bool banned;
  Role role;

  User(this.id, this.mobile, this.banned, this.role);
}