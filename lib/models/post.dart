class Post {
  late int id;
  late int createdAt;
  late String type;
  late String title;
  late String body;
  String? url;

  Post.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    createdAt = map['createdAt'];
    type = map['type'];
    title = map['title'];
    body = map['body'];
    url = map['url'];
  }
}