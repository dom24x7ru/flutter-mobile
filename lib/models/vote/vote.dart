import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/vote/vote_answer.dart';
import 'package:dom24x7_flutter/models/vote/vote_question.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'vote.g.dart';

@HiveType(typeId: 23)
class Vote extends Model {
  @HiveField(1)
  late int userId;
  @HiveField(2)
  late String title;
  @HiveField(3)
  late int createdAt;
  @HiveField(4)
  late int updatedAt;
  @HiveField(5)
  late bool multi;
  @HiveField(6)
  late bool anonymous;
  @HiveField(7)
  late bool closed;
  @HiveField(8)
  late bool house;
  @HiveField(9)
  int? section;
  @HiveField(10)
  int? floor;
  @HiveField(11)
  late int persons;
  @HiveField(12)
  late List<VoteQuestion> questions = [];
  @HiveField(13)
  late List<VoteAnswer> answers = [];

  Vote(id, this.userId, this.title, this.createdAt, this.updatedAt, this.multi, this.anonymous, this.closed, this.house, this.section, this.floor, this.persons, this.questions, this.answers) : super(id);

  Vote.fromMap(Map<String, dynamic> map) : super(map['id']) {
    userId = map['user']['id'];
    title = map['title'];
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
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
      'updatedAt': updatedAt,
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