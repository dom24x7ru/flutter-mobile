import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/models/resident.dart';
import 'package:dom24x7_flutter/models/user.dart';
import 'package:dom24x7_flutter/utilities.dart';
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
  void addResident(Resident resident) {
    if (value == null) return;
    value!.residents = Utilities.addOrReplaceById(value!.residents, resident);
  }

  @action
  void setResidents(List<Resident> residents) {
    if (value == null) return;
    value!.residents = residents;
  }

  @action
  void clear() {
    value = null;
  }
}