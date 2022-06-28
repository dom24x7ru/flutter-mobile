import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/mutual_help/mutual_help_category.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'mutual_help_item.g.dart';

@HiveType(typeId: 36)
class MutualHelpItem extends Model {
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String body;
  @HiveField(3)
  late bool deleted;
  @HiveField(4)
  late MutualHelpCategory category;
  @HiveField(5)
  late Person person;
  @HiveField(6)
  late Flat flat;
  @HiveField(7)
  late int updatedAt;

  MutualHelpItem(id, this.title, this.body, this.deleted, this.category, this.person, this.flat) : super(id);

  MutualHelpItem.fromMap(Map<String, dynamic> map) : super(map['id']) {
    title = map['title'];
    body = map['body'];
    deleted = map['deleted'];
    category = MutualHelpCategory.fromMap(map['category']);
    person = Person.fromMap(map['person']);
    flat = Flat.fromMap(map['person']['flat']);
    updatedAt = map['updatedAt'];
  }

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'title': title, 'body': body, 'deleted': deleted, 'category': category.toMap(), 'person': person.toMap(), 'flat': flat.toMap(), 'updatedAt': updatedAt };
  }
}