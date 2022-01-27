class InstructionItem {
  late int id;
  late String title;

  InstructionItem(this.id, this.title);
}

class Instruction {
  late int id;
  late String title;
  late String subtitle;
  late List<InstructionItem> body;

  Instruction.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    subtitle = map['subtitle'];
    body = [];
    for (var item in map['body']) {
      body.add(InstructionItem(item['id'], item['title']));
    }
  }
}