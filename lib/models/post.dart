import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'post.g.dart';

@HiveType(typeId: 15)
class Post extends Model {
  @HiveField(1)
  late int createdAt;
  @HiveField(2)
  late int updatedAt;
  @HiveField(3)
  late String type;
  @HiveField(4)
  late String title;
  @HiveField(5)
  late String body;
  @HiveField(6)
  String? url;

  Post(id, this.createdAt, this.updatedAt, this.type, this.title, this.body, this.url) : super(id);

  Post.fromMap(Map<String, dynamic> map) : super(map['id']) {
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    type = map['type'];
    title = map['title'];
    body = map['body'];
    url = map['url'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'createdAt': createdAt, 'updatedAt': updatedAt, 'type': type, 'title': title, 'body': body };
    if (url != null) map['url'] = url;
    return map;
  }
}