// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FAQStore on _FAQStore, Store {
  late final _$listAtom = Atom(name: '_FAQStore.list', context: context);

  @override
  List<FAQItem>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<FAQItem>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  late final _$_FAQStoreActionController =
      ActionController(name: '_FAQStore', context: context);

  @override
  void addFAQItem(FAQItem item) {
    final _$actionInfo =
        _$_FAQStoreActionController.startAction(name: '_FAQStore.addFAQItem');
    try {
      return super.addFAQItem(item);
    } finally {
      _$_FAQStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFAQItems(List<FAQItem> items) {
    final _$actionInfo =
        _$_FAQStoreActionController.startAction(name: '_FAQStore.setFAQItems');
    try {
      return super.setFAQItems(items);
    } finally {
      _$_FAQStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo =
        _$_FAQStoreActionController.startAction(name: '_FAQStore.clear');
    try {
      return super.clear();
    } finally {
      _$_FAQStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
