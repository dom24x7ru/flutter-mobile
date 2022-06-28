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
  late bool multi;
  @HiveField(5)
  late bool anonymous;
  @HiveField(6)
  late bool closed;
  @HiveField(7)
  late bool house;
  @HiveField(8)
  int? section;
  @HiveField(9)
  int? floor;
  @HiveField(10)
  late int persons;
  @HiveField(11)
  late List<VoteQuestion> questions = [];
  @HiveField(12)
  late List<VoteAnswer> answers = [];

  Vote(id, this.userId, this.title, this.createdAt, this.multi, this.anonymous, this.closed, this.house, this.section, this.floor, this.persons, this.questions, this.answers) : super(id);

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