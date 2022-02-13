import 'package:dom24x7_flutter/models/vote.dart';
import 'package:dom24x7_flutter/pages/services/votes/answered_page.dart';
import 'package:dom24x7_flutter/pages/services/votes/create_page.dart';
import 'package:dom24x7_flutter/pages/services/votes/vote_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => const VoteCreatePage())) },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add)
      ),
      body: ListView.builder(
        itemCount: votes.length,
        itemBuilder: (BuildContext context, int index) {
          final vote = votes[votes.length - index - 1];
          final createdAt = Utilities.getDateFormat(vote.createdAt);
          final List<Widget> status = [];
          if (answered(store, vote)) status.add(const Icon(Icons.done, color: Colors.green, size: 15.0));
          if (vote.closed) status.add(const Icon(Icons.block, color: Colors.red, size: 15.0));

          return GestureDetector(
            child: Card(
                child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vote.title.toUpperCase()),
                          Text(createdAt, style: const TextStyle(color: Colors.black26)),
                          Container(padding: const EdgeInsets.all(10.0)),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Проголосовало ${vote.answers.length} из ${vote.persons}'),
                                Row(mainAxisAlignment: MainAxisAlignment.end, children: status)
                              ]
                          )
                        ]
                    )
                )
            ),
            onTap: () => { gotoVote(context, store, vote) }
          );
        }
      )
    );
  }

  bool answered(MainStore store, Vote vote) {
    final answers = vote.answers;
    if (answers.isEmpty) return false;

    final person = store.user.value!.person;
    if (person == null) return false;
    
    return answers.where((answer) => answer.person.id == person.id).isNotEmpty;
  }

  void gotoVote(BuildContext context, MainStore store, Vote vote) {
    if (vote.closed || answered(store, vote)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VoteAnsweredPage(vote)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VotePage(vote)));
    }
  }
}
