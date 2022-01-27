class FAQItem {
  late int id;
  late String title;
  late String body;

  FAQItem(this.id, this.title, this.body);
  FAQItem.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
  }
}