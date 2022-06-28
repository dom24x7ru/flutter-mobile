import 'package:dom24x7_flutter/models/faq/faq_category.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'faq_item.g.dart';

@HiveType(typeId: 32)
class FAQItem extends Model {
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String body;
  @HiveField(3)
  late FAQCategory category;
  @HiveField(4)
  late int updatedAt;

  FAQItem(id, this.title, this.body, this.category, this.updatedAt) : super(id);

  FAQItem.fromMap(Map<String, dynamic> map) : super(map['id']) {
    title = map['title'];
    body = map['body'];
    category = FAQCategory.fromMap(map['category']);
    updatedAt = map['updatedAt'];
  }

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'body': body, 'category': category.toMap(), 'updatedAt': updatedAt };
  }
}