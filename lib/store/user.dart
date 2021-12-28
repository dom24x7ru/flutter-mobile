import 'package:dom24x7_flutter/models/user.dart';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  @observable
  User? value;

  @action
  void setUser(User? user) {
    this.value = user;
  }

  @action
  void clear() {
    value = null;
  }
}