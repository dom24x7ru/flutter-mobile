class FAQCategory {
  late int id;
  late String name;
  String? description;

  FAQCategory.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    description = map['description'];
  }
}

class FAQItem {
  late int id;
  late String title;
  late String body;
  late FAQCategory category;

  FAQItem(this.id, this.title, this.body);
  FAQItem.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
    category = FAQCategory.fromMap(map['category']);
  }
}