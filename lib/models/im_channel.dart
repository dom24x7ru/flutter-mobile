import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/im_message.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/person.dart';

class IMPerson {
  final Person person;
  final Flat flat;

  IMPerson(this.person, this.flat);

  Map<String, dynamic> toMap() {
    return { 'person': person.toMap(), 'flat': flat.toMap() };
  }
}

class IMChannel extends Model {
  String? title;
  late bool private;
  IMMessage? lastMessage;
  late int count;
  List<IMPerson> persons = [];

  IMChannel.fromMap(Map<String, dynamic> map) : super(map['id']) {
    title = map['title'];
    private = map['private'];
    lastMessage = map['lastMessage'] != null ? IMMessage.fromMap(map['lastMessage']) : null;
    count = map['count'];
    if (map['persons'] != null) {
      for (var person in map['persons']) {
        persons.add(IMPerson(Person.fromMap(person), Flat.fromMap(person['flat'])));
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id };
    if (title != null) map['title'] = title;
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