// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserStore, Store {
  final _$valueAtom = Atom(name: '_UserStore.value');

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

  final _$_UserStoreActionController = ActionController(name: '_UserStore');

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
  void setResident(Resident? resident) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.setResident');
    try {
      return super.setResident(resident);
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
