import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/im/im_channel.dart';
import 'package:dom24x7_flutter/models/im/im_message_body.dart';
import 'package:dom24x7_flutter/models/im/im_message_extra.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'im_message.g.dart';

@HiveType(typeId: 17)
class IMMessage extends Model {
  @HiveField(1)
  late String guid;
  @HiveField(2)
  late int createdAt;
  @HiveField(3)
  late int? updatedAt;
  @HiveField(4)
  IMPerson? imPerson;
  @HiveField(5)
  IMChannel? channel;
  @HiveField(6)
  IMMessageBody? body;
  @HiveField(7)
  IMMessageExtra? extra;

  IMMessage(id, this.guid, this.createdAt, this.updatedAt, this.imPerson, this.channel, this.body, this.extra) : super(id);

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