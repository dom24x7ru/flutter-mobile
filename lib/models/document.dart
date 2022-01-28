class Document {
  late int id;
  late String title;
  String? annotation;
  late String url;

  Document(this.id, this.title, this.url);
  Document.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    annotation = map['annotation'];
    url = map['url'];
  }
}