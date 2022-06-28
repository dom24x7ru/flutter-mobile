import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'document.g.dart';

@HiveType(typeId: 30)
class Document extends Model {
  @HiveField(1)
  late String title;
  @HiveField(2)
  String? annotation;
  @HiveField(3)
  late String url;
  @HiveField(4)
  late int updatedAt;

  Document(id, this.title, this.annotation, this.url, this.updatedAt) : super(id);
  Document.fromMap(Map<String, dynamic> map) : super(map['id']) {
    title = map['title'];
    annotation = map['annotation'];
    url = map['url'];
    updatedAt = map['updatedAt'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'title': title, 'url': url, 'updatedAt': updatedAt };
    if (annotation != null) map['annotation'] = annotation;
    return map;
  }
}