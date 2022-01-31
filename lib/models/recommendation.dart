import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/person.dart';

class RecommendationExtra {
  String? phone;
  String? site;
  String? email;
  String? address;
  String? instagram;
  String? telegram;

  RecommendationExtra.fromMap(Map<String, dynamic> map) {
    phone = map['phone'];
    site = map['site'];
    email = map['email'];
    address = map['address'];
    instagram = map['instagram'];
    telegram = map['telegram'];
  }
}

class RecommendationCategory {
  late int id;
  late String name;
  late String img;
  late int sort;
  int count = 0;

  RecommendationCategory.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    img = map['img'];
    sort = map['sort'];
  }
}

class Recommendation {
  late int id;
  late String title;
  late String body;
  late bool deleted;
  late RecommendationExtra extra;
  late RecommendationCategory category;
  late Person person;
  late Flat flat;

  Recommendation.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
    deleted = map['deleted'];
    extra = RecommendationExtra.fromMap(map['extra']);
    category = RecommendationCategory.fromMap(map['category']);
    person = Person.fromMap(map['person']);
    flat = Flat.fromMap(map['person']['flat']);
  }
}