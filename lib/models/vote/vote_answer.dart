import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:dom24x7_flutter/models/vote/vote_question.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'vote_answer.g.dart';

@HiveType(typeId: 24)
class VoteAnswer extends Model {
  @HiveField(1)
  late VoteQuestion question;
  @HiveField(2)
  late Person person;
  @HiveField(3)
  late Flat flat;

  VoteAnswer(id, this.question, this.person, this.flat) : super(id);

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