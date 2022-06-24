import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/person.dart';

class VoteQuestion extends Model {
  String? body;

  VoteQuestion.fromMap(Map<String, dynamic> map) : super(map['id']) {
    body = map['body'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id };
    if (body != null) map['body'] = body;
    return map;
  }
}

class VoteAnswer extends Model {
  late VoteQuestion question;
  late Person person;
  late Flat flat;

  VoteAnswer.fromMap(Map<String, dynamic> map) : super(map['id']) {
    question = VoteQuestion.fromMap(map['question']);
    person = Person.fromMap(map['person']);
    flat = Flat.fromMap(map['person']['flat']);
  }

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'question': question.toMap(), 'person': person.toMap(), 'flat': flat.toMap() };
  }
}

class Vote extends Model {
  late int userId;
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

  Vote.fromMap(Map<String, dynamic> map) : super(map['id']) {
    userId = map['user']['id'];
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

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'userId': userId,
      'title': title,
      'createdAt': createdAt,
      'multi': multi,
      'anonymous': anonymous,
      'closed': closed,
      'house': house,
      'persons': persons,
      'questions': [],
      'answers': []
    };
    if (section != null) map['section'] = section;
    if (floor != null) map['floor'] = floor;
    for (var question in questions) {
      map['questions'].add(question.toMap());
    }
    for (var answer in answers) {
      map['answers'].add(answer.toMap());
    }
    return map;
  }
}