import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/im_channel.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/person.dart';

class IMMessageHistoryItem {
  late int createdAt;
  late String text;

  IMMessageHistoryItem.fromMap(Map<String, dynamic> map) {
    createdAt = map['createdAt'];
    text = map['text'];
  }
}

class IMMessageBody {
  late String text;
  late List<IMMessageHistoryItem> history = [];
  IMMessage? aMessage;

  IMMessageBody.fromMap(Map<String, dynamic> map) {
    text = map['text'];
    if (map['history'] != null) {
      for (var item in map['history']) {
        history.add(IMMessageHistoryItem.fromMap(item));
      }
    }
    aMessage = map['aMessage'] != null ? IMMessage.fromMap(map['aMessage']) : null;
  }
}

class IMMessage extends Model {
  late int createdAt;
  IMPerson? imPerson;
  IMMessageBody? body;

  IMMessage.fromMap(Map<String, dynamic> map) : super(map['id']) {
    createdAt = map['createdAt'];
    final person = map['person'];
    imPerson = person != null ? IMPerson(Person.fromMap(person), Flat.fromMap(person['flat'])) : null;
    body = map['body'] != null ? IMMessageBody.fromMap(map['body']) : null; // не будет в ответе
  }
}