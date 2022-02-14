import 'package:dom24x7_flutter/models/model.dart';

class InstructionItem extends Model {
  late String title;

  InstructionItem(id, this.title) : super(id);
}

class Instruction extends Model {
  late String title;
  late String subtitle;
  late List<InstructionItem> body;

  Instruction.fromMap(Map<String, dynamic> map) : super(map['id']) {
    title = map['title'];
    subtitle = map['subtitle'];
    body = [];
    for (var item in map['body']) {
      body.add(InstructionItem(item['id'], item['title']));
    }
  }
}