// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DocumentsStore on _DocumentsStore, Store {
  final _$listAtom = Atom(name: '_DocumentsStore.list');

  @override
  List<Document>? get list {
    _$listAtom.reportRead();
    return super.list;
  }

  @override
  set list(List<Document>? value) {
    _$listAtom.reportWrite(value, super.list, () {
      super.list = value;
    });
  }

  final _$_DocumentsStoreActionController =
      ActionController(name: '_DocumentsStore');

  @override
  void addDocument(Document document) {
    final _$actionInfo = _$_DocumentsStoreActionController.startAction(
        name: '_DocumentsStore.addDocument');
    try {
      return super.addDocument(document);
    } finally {
      _$_DocumentsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDocuments(List<Document> documents) {
    final _$actionInfo = _$_DocumentsStoreActionController.startAction(
        name: '_DocumentsStore.setDocuments');
    try {
      return super.setDocuments(documents);
    } finally {
      _$_DocumentsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_DocumentsStoreActionController.startAction(
        name: '_DocumentsStore.clear');
    try {
      return super.clear();
    } finally {
      _$_DocumentsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
list: ${list}
    ''';
  }
}
