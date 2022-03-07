import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/im_message.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/person.dart';

class IMPerson {
  final Person person;
  final Flat flat;
  IMPerson(this.person, this.flat);
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
}