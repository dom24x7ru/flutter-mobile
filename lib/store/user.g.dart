// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserStore, Store {
  late final _$valueAtom = Atom(name: '_UserStore.value', context: context);

  @override
  User? get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(User? value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  late final _$_UserStoreActionController =
      ActionController(name: '_UserStore', context: context);

  @override
  void setUser(User? user) {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.setUser');
    try {
      return super.setUser(user);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPerson(Person? person) {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.setPerson');
    try {
      return super.setPerson(person);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addResident(Resident resident) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.addResident');
    try {
      return super.addResident(resident);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setResidents(List<Resident> residents) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setResidents');
    try {
      return super.setResidents(residents);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.clear');
    try {
      return super.clear();
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value}
    ''';
  }
}
