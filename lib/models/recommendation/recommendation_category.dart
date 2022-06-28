import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'recommendation_category.g.dart';

@HiveType(typeId: 38)
class RecommendationCategory extends Model {
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String img;
  @HiveField(3)
  late int sort;
  @HiveField(4)
  int count = 0;

  RecommendationCategory(id, this.name, this.img, this.sort, this.count) : super(id);

  RecommendationCategory.fromMap(Map<String, dynamic> map) : super(map['id']) {
    name = map['name'];
    img = map['img'];
    sort = map['sort'];
  }

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'name': name, 'img': img, 'sort': sort, 'count': count };
  }
}