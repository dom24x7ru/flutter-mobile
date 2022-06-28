import 'package:dom24x7_flutter/models/model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'instruction_item.g.dart';

@HiveType(typeId: 34)
class InstructionItem extends Model {
  @HiveField(1)
  late String title;

  InstructionItem(id, this.title) : super(id);

  @override
  Map<String, dynamic> toMap() {
    return { 'id': id, 'title': title };
  }
}