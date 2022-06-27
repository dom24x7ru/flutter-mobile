import 'package:dom24x7_flutter/models/im/im_image.dart';
import 'package:dom24x7_flutter/models/im/im_message.dart';
import 'package:dom24x7_flutter/models/im/im_message_history_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'im_message_body.g.dart';

@HiveType(typeId: 19)
class IMMessageBody {
  @HiveField(1)
  String? text;
  @HiveField(2)
  IMImage? image;
  @HiveField(3)
  late List<IMMessageHistoryItem> history = [];
  @HiveField(4)
  IMMessage? aMessage;

  IMMessageBody(this.text, this.image, this.history, this.aMessage);

  IMMessageBody.fromMap(Map<String, dynamic> map) {
    text = map['text'];
    if (map['image'] != null) image = IMImage.fromMap(map['image']);
    if (map['history'] != null) {
      for (var item in map['history']) {
        history.add(IMMessageHistoryItem.fromMap(item));
      }
    }
    aMessage = map['aMessage'] != null ? IMMessage.fromMap(map['aMessage']) : null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (text != null) map['text'] = text;
    if (image != null) map['image'] = image!.toMap();
    if (history.isNotEmpty) {
      map['history'] = [];
      for (var item in history) {
        map['history'].add(item.toMap());
      }
    }
    if (aMessage != null) map['aMessage'] = aMessage!.toMap();
    return map;
  }
}