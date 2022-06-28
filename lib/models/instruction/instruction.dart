import 'package:dom24x7_flutter/models/instruction/instruction_item.dart';
import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'instruction.g.dart';

@HiveType(typeId: 33)
class Instruction extends Model {
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String subtitle;
  @HiveField(3)
  late List<InstructionItem> body;
  @HiveField(4)
  late int updatedAt;

  Instruction(id, this.title, this.subtitle, this.body) : super(id);

  Instruction.fromMap(Map<String, dynamic> map) : super(map['id']) {
    title = map['title'];
    subtitle = map['subtitle'];
    body = [];
    for (var item in map['body']) {
      body.add(InstructionItem(item['id'], item['title']));
    }
    updatedAt = map['updatedAt'];
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = { 'id': id, 'title': title, 'subtitle': subtitle, 'body': [], 'updatedAt': updatedAt };
    for (var item in body) {
      map['body'].add(item.toMap());
    }
    return map;
  }
}