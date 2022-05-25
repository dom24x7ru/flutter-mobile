// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MainStore on _MainStore, Store {
  late final _$_MainStoreActionController =
      ActionController(name: '_MainStore', context: context);

  @override
  void setClient(SocketClient client) {
    final _$actionInfo =
        _$_MainStoreActionController.startAction(name: '_MainStore.setClient');
    try {
      return super.setClient(client);
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoaded(bool status) {
    final _$actionInfo =
        _$_MainStoreActionController.startAction(name: '_MainStore.setLoaded');
    try {
      return super.setLoaded(status);
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_MainStoreActionController.startAction(name: '_MainStore.clear');
    try {
      return super.clear();
    } finally {
      _$_MainStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
