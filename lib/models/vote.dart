import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/person.dart';

class VoteQuestion {
  late int id;
  String? body;

  VoteQuestion.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    body = map['body'];
  }
}

class VoteAnswer {
  late int id;
  late VoteQuestion question;
  late Person person;
  late Flat flat;

  VoteAnswer.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    question = VoteQuestion.fromMap(map['question']);
    person = Person.fromMap(map['person']);
    flat = Flat.fromMap(map['person']['flat']);
  }
}

class Vote {
  late int id;
  late String title;
  late int createdAt;
  late bool multi;
  late bool anonymous;
  late bool closed;
  late bool house;
  int? section;
  int? floor;
  late int persons;
  late List<VoteQuestion> questions = [];
  late List<VoteAnswer> answers = [];

  Vote.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    createdAt = map['createdAt'];
    multi = map['multi'];
    anonymous = map['anonymous'];
    closed = map['closed'];
    house = map['house'];
    section = map['section'];
    floor = map['floor'];
    persons = map['persons'];
    for (var question in map['questions']) {
      questions.add(VoteQuestion.fromMap(question));
    }
    for (var answer in map['answers']) {
      answers.add(VoteAnswer.fromMap(answer));
    }
  }
}