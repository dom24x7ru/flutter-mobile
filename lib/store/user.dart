import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/models/resident.dart';
import 'package:dom24x7_flutter/models/user.dart';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  @observable
  User? value;

  @action
  void setUser(User? user) {
    value = user;
  }

  @action
  void setPerson(Person? person) {
    if (value == null) return;
    value!.person = person;
  }

  @action
  void setResident(Resident? resident) {
    if (value == null) return;
    value!.resident = resident;
  }

  @action
  void clear() {
    value = null;
  }
}