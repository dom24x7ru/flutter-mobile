class Document {
  late int id;
  late String title;
  late String url;

  Document(this.id, this.title, this.url);
  Document.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    url = map['url'];
  }
}