import 'package:dom24x7_flutter/models/model.dart';

class FAQCategory extends Model {
  late String name;
  String? description;

  FAQCategory.fromMap(Map<String, dynamic> map) : super(map['id']) {
    name = map['name'];
    description = map['description'];
  }
}

class FAQItem extends Model {
  late String title;
  late String body;
  late FAQCategory category;

  FAQItem(id, this.title, this.body) : super(id);
  FAQItem.fromMap(Map<String, dynamic> map) : super(map['id']) {
    title = map['title'];
    body = map['body'];
    category = FAQCategory.fromMap(map['category']);
  }
}