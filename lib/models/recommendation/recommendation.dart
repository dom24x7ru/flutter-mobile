import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/recommendation/recommendation_category.dart';
import 'package:dom24x7_flutter/models/recommendation/recommendation_extra.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'recommendation.g.dart';

@HiveType(typeId: 37)
class Recommendation extends Model {
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String body;
  @HiveField(3)
  late bool deleted;
  @HiveField(4)
  late RecommendationExtra extra;
  @HiveField(5)
  late RecommendationCategory category;
  @HiveField(6)
  late Person person;
  @HiveField(7)
  late Flat flat;
  @HiveField(8)
  late int updatedAt;

  Recommendation(id, this.title, this.body, this.deleted, this.extra, this.category, this.person, this.flat, this.updatedAt) : super(id);

  Recommendation.fromMap(Map<String, dynamic> map) : super(map['id']) {
    title = map['title'];
    body = map['body'];
    deleted = map['deleted'];
    extra = RecommendationExtra.fromMap(map['extra']);
    category = RecommendationCategory.fromMap(map['category']);
    person = Person.fromMap(map['person']);
    flat = Flat.fromMap(map['person']['flat']);
    updatedAt = map['updatedAt'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'deleted': deleted,
      'extra': extra.toMap(),
      'category': category.toMap(),
      'person': person.toMap(),
      'flat': flat.toMap(),
      'updatedAt': updatedAt
    };
  }
}