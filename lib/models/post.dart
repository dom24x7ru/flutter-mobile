import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'post.g.dart';

@HiveType(typeId: 15)
class Post extends Model {
  @HiveField(1)
  late int createdAt;
  @HiveField(2)
  late String type;
  @HiveField(3)
  late String title;
  @HiveField(4)
  late String body;
  @HiveField(5)
  String? url;

  Post(id, this.createdAt, this.type, this.title, this.body, this.url) : super(id);
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