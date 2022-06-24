import 'package:dom24x7_flutter/models/model.dart';

class Document extends Model {
  late String title;
  String? annotation;
  late String url;

  Document(id, this.title, this.url) : super(id);
  Document.fromMap(Map<String, dynamic> map) : super(map['id']) {
    title = map['title'];
    annotation = map['annotation'];
    url = map['url'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'title': title, 'url': url };
    if (annotation != null) map['annotation'] = annotation;
    return map;
  }
}