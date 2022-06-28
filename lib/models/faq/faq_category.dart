import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'faq_category.g.dart';

@HiveType(typeId: 31)
class FAQCategory extends Model {
  @HiveField(1)
  late String name;
  @HiveField(2)
  String? description;

  FAQCategory(id, this.name, this.description) : super(id);

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