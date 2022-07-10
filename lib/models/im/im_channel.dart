import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/im/im_message.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'im_channel.g.dart';

@HiveType(typeId: 16)
class IMChannel extends Model {
  @HiveField(1)
  String? title;
  @HiveField(2)
  bool? allHouse;
  @HiveField(3)
  bool? private;
  @HiveField(4)
  IMMessage? lastMessage;
  @HiveField(5)
  late int count;
  @HiveField(6)
  List<IMPerson> persons = [];
  @HiveField(7)
  int? updatedAt;

  IMChannel(id, this.title, this.allHouse, this.private, this.lastMessage, this.count, this.persons) : super(id);

  IMChannel.fromMap(Map<String, dynamic> map) : super(map['id']) {
    title = map['title'];
    allHouse = map['allHouse'];
    private = map['private'];
    lastMessage = map['lastMessage'] != null ? IMMessage.fromMap(map['lastMessage']) : null;
    count = map['count'] ?? 0;

    if (map['persons'] != null) {
      for (var person in map['persons']) {
        IMPerson imPerson = IMPerson(
            Person.fromMap(person),
            Flat.fromMap(person['flat']),
            person['profilePhoto'] != null ? person['profilePhoto']['thumbnail'] : null,
            person['profilePhoto'] != null ? person['profilePhoto']['resized'] : null
        );
        persons.add(imPerson);
      }
    }
    updatedAt = map['updatedAt'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'updatedAt': updatedAt };
    if (title != null) map['title'] = title;
    map['allHouse'] = allHouse;
    map['private'] = private;
    if (lastMessage != null) map['lastMessage'] = lastMessage!.toMap();
    map['count'] = count;
    map['persons'] = [];
    for (var person in persons) {
      map['persons'].add(person.toMap());
    }
    return map;
  }
}