import 'package:dom24x7_flutter/models/model.dart';

class FAQCategory extends Model {
  late String name;
  String? description;

  FAQCategory.fromMap(Map<String, dynamic> map) : super(map['id']) {
    name = map['name'];
    description = map['description'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'name': name };
    if (description != null) map['description'] = description;
    return map;
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

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'body': body, 'category': category.toMap() };
  }
}