import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VotesListPage extends StatelessWidget {
  const VotesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final votes = store.votes.list!;

    return Scaffold(
      appBar: Header(context, 'Голосования'),
      bottomNavigationBar: Footer(context, FooterNav.services),
      body: ListView.builder(
        itemCount: votes.length,
        itemBuilder: (BuildContext context, int index) {
          final vote = votes[votes.length - index - 1];
          final createdAt = DateFormat('dd.MM.y HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(vote.createdAt));
          final List<Widget> status = [
            const Icon(Icons.done, color: Colors.green),
            const Icon(Icons.block, color: Colors.red)
          ];
          return Card(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vote.title.toUpperCase()),
                  Text(createdAt, style: const TextStyle(color: Colors.black26)),
                  Container(padding: const EdgeInsets.all(10.0)),
                  Text('Проголосовало ${vote.answers.length} из ${vote.persons}'),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: status)
                ]
              )
            )
          );
        }
      )
    );
  }
}
