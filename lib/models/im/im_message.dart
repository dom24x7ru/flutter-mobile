import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/im/im_channel.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/person.dart';

class IMImage extends Model {
  late String name;
  late int size;
  late String uri;
  late int width;
  late int height;

  IMImage.fromMap(Map<String, dynamic> map) : super(map['id']) {
    name = map['name'];
    size = map['size'];
    uri = map['uri'];
    width = map['width'];
    height = map['height'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'uri': uri,
      'width': width,
      'height': height
    };
  }
}

class IMMessageHistoryItem {
  late int createdAt;
  late String text;

  IMMessageHistoryItem.fromMap(Map<String, dynamic> map) {
    createdAt = map['createdAt'];
    text = map['text'];
  }

  Map<String, dynamic> toMap() {
    return { 'createdAt': createdAt, 'text': text };
  }
}

class IMMessageBody {
  String? text;
  IMImage? image;
  late List<IMMessageHistoryItem> history = [];
  IMMessage? aMessage;

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

class IMMessageExtra {
  List<int> shown = [];

  IMMessageExtra.fromMap(Map<String, dynamic> map) {
    for (var personId in map['shown']) {
      shown.add(personId);
    }
  }

  Map<String, dynamic> toMap() {
    return { 'shown': shown };
  }
}

class IMMessage extends Model {
  late String guid;
  late int createdAt;
  late int? updatedAt;
  IMPerson? imPerson;
  IMChannel? channel;
  IMMessageBody? body;
  IMMessageExtra? extra;

  IMMessage.fromMap(Map<String, dynamic> map) : super(map['id']) {
    guid = map['guid'];
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
    final person = map['person'];
    imPerson = person != null ? IMPerson(Person.fromMap(person), Flat.fromMap(person['flat'])) : null;
    channel = map['channel'] != null ? IMChannel.fromMap(map['channel']) : null;
    body = map['body'] != null ? IMMessageBody.fromMap(map['body']) : null; // не будет в ответе
    extra = map['extra'] != null ? IMMessageExtra.fromMap(map['extra']) : null;
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'createdAt': createdAt  };
    if (updatedAt != null) map['updatedAt'] = updatedAt;
    if (imPerson != null) map['imPerson'] = imPerson!.toMap();
    if (channel != null) map['channel'] = channel!.toMap();
    if (body != null) map['body'] = body!.toMap();
    if (extra != null) map['extra'] = extra!.toMap();
    return map;
  }
}