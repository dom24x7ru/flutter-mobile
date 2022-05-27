// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'miniapps.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MiniAppsStore on _MiniAppsStore, Store {
  late final _$listAtom = Atom(name: '_MiniAppsStore.list', context: context);

  @override
  List<MiniApp>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<MiniApp>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  late final _$_MiniAppsStoreActionController =
      ActionController(name: '_MiniAppsStore', context: context);

  @override
  void addMiniApp(MiniApp miniApp) {
    final _$actionInfo = _$_MiniAppsStoreActionController.startAction(
        name: '_MiniAppsStore.addMiniApp');
    try {
      return super.addMiniApp(miniApp);
    } finally {
      _$_MiniAppsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMiniApps(List<MiniApp> miniApps) {
    final _$actionInfo = _$_MiniAppsStoreActionController.startAction(
        name: '_MiniAppsStore.setMiniApps');
    try {
      return super.setMiniApps(miniApps);
    } finally {
      _$_MiniAppsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_MiniAppsStoreActionController.startAction(
        name: '_MiniAppsStore.clear');
    try {
      return super.clear();
    } finally {
      _$_MiniAppsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
