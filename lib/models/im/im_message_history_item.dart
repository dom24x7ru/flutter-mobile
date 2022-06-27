import 'package:hive_flutter/hive_flutter.dart';

part 'im_message_history_item.g.dart';

@HiveType(typeId: 20)
class IMMessageHistoryItem {
  @HiveField(1)
  late int createdAt;
  @HiveField(2)
  late String text;

  IMMessageHistoryItem(this.createdAt, this.text);

  IMMessageHistoryItem.fromMap(Map<String, dynamic> map) {
    createdAt = map['createdAt'];
    text = map['text'];
  }

  Map<String, dynamic> toMap() {
    return { 'createdAt': createdAt, 'text': text };
  }
}