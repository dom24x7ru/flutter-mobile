import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'vote_question.g.dart';

@HiveType(typeId: 25)
class VoteQuestion extends Model {
  @HiveField(1)
  String? body;

  VoteQuestion(id, this.body) : super(id);

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