import 'package:dom24x7_flutter/pages/services/instructions/instruction_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final instructions = store.instructions.list!;

    return Scaffold(
      appBar: Header.get(context, 'Инструкции'),
      bottomNavigationBar: const Footer(FooterNav.services),
      body: ListView.separated(
        itemCount: instructions.length,
        itemBuilder: (BuildContext context, int index) {
          final instruction = instructions[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InstructionPage(instruction))),
            child: ListTile(
              title: Text(instruction.title),
              subtitle: instruction.subtitle.isNotEmpty ? Text(instruction.subtitle) : null
            )
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        }
      )
    );
  }
}
