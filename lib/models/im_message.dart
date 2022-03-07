import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/person.dart';

class IMMessageBodyAnswer extends Model {
  late int createdAt;
  late String text;

  IMMessageBodyAnswer.fromMap(Map<String, dynamic> map) : super(map['id']) {
    createdAt = map['createdAt'];
    text = map['text'];
  }
}

class IMMessageBody {
  late String text;
  IMMessageBodyAnswer? aMessage;

  IMMessageBody.fromMap(Map<String, dynamic> map) {
    text = map['text'];
    aMessage = map['aMessage'] != null ? IMMessageBodyAnswer.fromMap(map['aMessage']) : null;
  }
}

class IMMessage extends Model {
  late int createdAt;
  Person? person;
  late IMMessageBody body;

  IMMessage.fromMap(Map<String, dynamic> map) : super(map['id']) {
    createdAt = map['createdAt'];
    person = map['person'] != null ? Person.fromMap(map['person']) : null;
    body = IMMessageBody.fromMap(map['body']);
  }
}