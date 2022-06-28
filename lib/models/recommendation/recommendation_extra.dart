import 'package:hive_flutter/hive_flutter.dart';

part 'recommendation_extra.g.dart';

@HiveType(typeId: 39)
class RecommendationExtra {
  @HiveField(1)
  String? phone;
  @HiveField(2)
  String? site;
  @HiveField(3)
  String? email;
  @HiveField(4)
  String? address;
  @HiveField(5)
  String? instagram;
  @HiveField(6)
  String? telegram;

  RecommendationExtra(this.phone, this.site, this.email, this.address, this.instagram, this.telegram);

  RecommendationExtra.fromMap(Map<String, dynamic> map) {
    phone = map['phone'];
    site = map['site'];
    email = map['email'];
    address = map['address'];
    instagram = map['instagram'];
    telegram = map['telegram'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (phone != null) map['phone'] = phone;
    if (site != null) map['site'] = site;
    if (email != null) map['email'] = email;
    if (address != null) map['address'] = address;
    if (instagram != null) map['instagram'] = instagram;
    if (telegram != null) map['telegram'] = telegram;
    return map;
  }
}