import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/person.dart';

class MutualHelpCategory extends Model {
  late String name;
  late String img;
  late int sort;
  int count = 0;

  MutualHelpCategory.fromMap(Map<String, dynamic> map) : super(map['id']) {
    name = map['name'];
    img = map['img'];
    sort = map['sort'];
  }

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'name': name, 'img': img, 'sort': sort, 'count': count };
  }
}

class MutualHelpItem extends Model {
  late String title;
  late String body;
  late bool deleted;
  late MutualHelpCategory category;
  late Person person;
  late Flat flat;

  MutualHelpItem.fromMap(Map<String, dynamic> map) : super(map['id']) {
    title = map['title'];
    body = map['body'];
    deleted = map['deleted'];
    category = MutualHelpCategory.fromMap(map['category']);
    person = Person.fromMap(map['person']);
    flat = Flat.fromMap(map['person']['flat']);
  }

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'title': title, 'body': body, 'deleted': deleted, 'category': category.toMap(), 'person': person.toMap(), 'flat': flat.toMap() };
  }
}