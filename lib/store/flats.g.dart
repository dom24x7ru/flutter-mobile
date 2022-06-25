// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flats.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FlatsStore on _FlatsStore, Store {
  late final _$listAtom = Atom(name: '_FlatsStore.list', context: context);

  @override
  List<Flat>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<Flat>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  late final _$_FlatsStoreActionController =
      ActionController(name: '_FlatsStore', context: context);

  @override
  void addFlat(Flat flat) {
    final _$actionInfo =
        _$_FlatsStoreActionController.startAction(name: '_FlatsStore.addFlat');
    try {
      return super.addFlat(flat);
    } finally {
      _$_FlatsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFlats(List<Flat> flats) {
    final _$actionInfo =
        _$_FlatsStoreActionController.startAction(name: '_FlatsStore.setFlats');
    try {
      return super.setFlats(flats);
    } finally {
      _$_FlatsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_FlatsStoreActionController.startAction(name: '_FlatsStore.clear');
    try {
      return super.clear();
    } finally {
      _$_FlatsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
