import 'package:dom24x7_flutter/models/instruction.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class InstructionPage extends StatelessWidget {
  final Instruction instruction;

  const InstructionPage(this.instruction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(context, getHeaderTitle(instruction.title)),
      bottomNavigationBar: Footer(context, FooterNav.services),
      body: ListView.builder(
        itemCount: instruction.body.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Card(
              child: Container(
                  padding: const EdgeInsets.all(15.0),
                  color: Colors.blue,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(instruction.title, style: const TextStyle(fontSize: 18.0, color: Colors.white)),
                        Text(instruction.subtitle, style: const TextStyle(color: Colors.white)),
                      ]
                  )
              )
            );
          }

          final item = instruction.body[index - 1];
          return ListTile(
            leading: const Icon(Icons.done),
            title: Text(item.title),
          );
        }
      )
    );
  }

  String getHeaderTitle(String title) {
    if (title.length < 20) return title;
    return title.substring(0, 20) + '...';
  }
}
