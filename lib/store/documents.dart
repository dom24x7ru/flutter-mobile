import 'package:dom24x7_flutter/models/document.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:mobx/mobx.dart';

part 'documents.g.dart';

class DocumentsStore = _DocumentsStore with _$DocumentsStore;

abstract class _DocumentsStore with Store {
  @observable
  List<Document>? list;

  @action
  void addDocument(Document document) {
    list = Utilities.addOrReplaceById(list, document);
  }

  @action
  void setDocuments(List<Document> documents) {
    list = documents;
  }

  @action
  void clear() {
    list = null;
  }
}