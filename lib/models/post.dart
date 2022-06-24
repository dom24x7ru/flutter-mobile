import 'package:dom24x7_flutter/models/model.dart';

class Post extends Model {
  late int createdAt;
  late String type;
  late String title;
  late String body;
  String? url;

  Post.fromMap(Map<String, dynamic> map) : super(map['id']) {
    createdAt = map['createdAt'];
    type = map['type'];
    title = map['title'];
    body = map['body'];
    url = map['url'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'createdAt': createdAt, 'type': type, 'title': title, 'body': body };
    if (url != null) map['url'] = url;
    return map;
  }
}