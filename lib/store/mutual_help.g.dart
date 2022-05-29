// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutual_help.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MutualHelpStore on _MutualHelpStore, Store {
  late final _$listAtom = Atom(name: '_MutualHelpStore.list', context: context);

  @override
  List<MutualHelpItem>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<MutualHelpItem>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  late final _$_MutualHelpStoreActionController =
      ActionController(name: '_MutualHelpStore', context: context);

  @override
  void addMutualHelpItem(MutualHelpItem item) {
    final _$actionInfo = _$_MutualHelpStoreActionController.startAction(
        name: '_MutualHelpStore.addMutualHelpItem');
    try {
      return super.addMutualHelpItem(item);
    } finally {
      _$_MutualHelpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void delMutualHelpItem(MutualHelpItem item) {
    final _$actionInfo = _$_MutualHelpStoreActionController.startAction(
        name: '_MutualHelpStore.delMutualHelpItem');
    try {
      return super.delMutualHelpItem(item);
    } finally {
      _$_MutualHelpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMutualHelpItems(List<MutualHelpItem> items) {
    final _$actionInfo = _$_MutualHelpStoreActionController.startAction(
        name: '_MutualHelpStore.setMutualHelpItems');
    try {
      return super.setMutualHelpItems(items);
    } finally {
      _$_MutualHelpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_MutualHelpStoreActionController.startAction(
        name: '_MutualHelpStore.clear');
    try {
      return super.clear();
    } finally {
      _$_MutualHelpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
