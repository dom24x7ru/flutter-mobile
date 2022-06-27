import 'package:hive_flutter/hive_flutter.dart';

part 'im_message_extra.g.dart';

@HiveType(typeId: 18)
class IMMessageExtra {
  @HiveField(1)
  List<int> shown = [];

  IMMessageExtra(this.shown);

  IMMessageExtra.fromMap(Map<String, dynamic> map) {
    for (var personId in map['shown']) {
      shown.add(personId);
    }
  }

  Map<String, dynamic> toMap() {
    return { 'shown': shown };
  }
}