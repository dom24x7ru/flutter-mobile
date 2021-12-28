// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$VersionStore on _VersionStore, Store {
  final _$currentAtom = Atom(name: '_VersionStore.current');

  @override
  Version? get current {
    _$currentAtom.reportRead();
    return super.current;
  }

  @override
  set current(Version? value) {
    _$currentAtom.reportWrite(value, super.current, () {
      super.current = value;
    });
  }

  final _$_VersionStoreActionController =
      ActionController(name: '_VersionStore');

  @override
  void setVersion(Version? version) {
    final _$actionInfo = _$_VersionStoreActionController.startAction(
        name: '_VersionStore.setVersion');
    try {
      return super.setVersion(version);
    } finally {
      _$_VersionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_VersionStoreActionController.startAction(
        name: '_VersionStore.clear');
    try {
      return super.clear();
    } finally {
      _$_VersionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
current: ${current}
    ''';
  }
}
