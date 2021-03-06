import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/vote/vote.dart';
import 'package:dom24x7_flutter/pages/services/votes/answered_page.dart';
import 'package:dom24x7_flutter/pages/services/votes/create_page.dart';
import 'package:dom24x7_flutter/pages/services/votes/vote_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VotesListPage extends StatefulWidget {
  const VotesListPage({Key? key}) : super(key: key);

  @override
  State<VotesListPage> createState() => _VotesListPageState();
}

class _VotesListPageState extends State<VotesListPage> {
  List<Vote> _votes = [];
  late SocketClient _client;
  final List<dynamic> _listeners = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;

      setState(() {
        if (store.votes.list == null) return;
        _votes = store.votes.list!;
      });
      var listener = _client.on('vote', this, (event, cont) {
        setState(() => _votes = store.votes.list!);
      });
      _listeners.add(listener);
      listener = _client.on('votes', this, (event, cont) {
        setState(() => _votes = store.votes.list!);
      });
    });
  }

  @override
  void dispose() {
    for (var listener in _listeners) {
      _client.off(listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    Widget? floatingActionButton;
    if (store.user.value!.residents.isNotEmpty) {
      floatingActionButton = FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VoteCreatePage())),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add)
      );
    }

    return Scaffold(
        appBar: Header.get(context, '??????????????????????'),
        bottomNavigationBar: const Footer(FooterNav.services),
        floatingActionButton: floatingActionButton,
        body: ListView.builder(
            itemCount: _votes.length,
            itemBuilder: (BuildContext context, int index) {
              final vote = _votes[_votes.length - index - 1];
              final createdAt = Utilities.getDateFormat(vote.createdAt);
              final List<Widget> status = [];
              if (_answered(store, vote)) status.add(const Icon(Icons.done, color: Colors.green, size: 15.0));
              if (vote.closed) status.add(const Icon(Icons.block, color: Colors.red, size: 15.0));

              final children = [
                Text(vote.title.toUpperCase()),
                Text(createdAt, style: const TextStyle(color: Colors.black26)),
                Container(padding: const EdgeInsets.all(10.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('?????????????????????????? ${vote.answers.length} ???? ${vote.persons}'),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: status)
                  ]
                )
              ];
              if (vote.anonymous) children.insert(2, const Text('?????????????????? ??????????????????????', style: TextStyle(color: Colors.black26)));

              return GestureDetector(
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children
                      )
                  )
                ),
                onTap: () => _gotoVote(context, store, vote),
                onLongPress: () => _showMenu(context, store, vote)
              );
            }
        )
    );
  }

  bool _answered(MainStore store, Vote vote) {
    final answers = vote.answers;
    if (answers.isEmpty) return false;

    final person = store.user.value!.person;
    if (person == null) return false;

    return answers.where((answer) => answer.person.id == person.id).isNotEmpty;
  }

  void _gotoVote(BuildContext context, MainStore store, Vote vote) {
    if (vote.closed || _answered(store, vote)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VoteAnsweredPage(vote)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VotePage(vote)));
    }
  }

  void _showMenu(BuildContext context, MainStore store, Vote vote) {
    final user = store.user.value!;
    if (user.id != vote.userId) return;

    Color color = vote.closed ? Colors.blue : Colors.red;
    String title = vote.closed ? '?????????????????????? ??????????????????????' : '?????????????????? ??????????????????????';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  final action = vote.closed ? 'vote.reopen' : 'vote.close';
                  store.client.socket.emit(action, { 'voteId': vote.id }, (String name, dynamic error, dynamic data) {
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
                      );
                      return;
                    }
                    if (data == null || data['status'] != 'OK') {
                      final message = vote.closed ? '???? ?????????????? ?????????????????????? ??????????????????????.' : '???? ?????????????? ?????????????? ??????????????????????.';
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$message ???????????????????? ??????????'), backgroundColor: Colors.red)
                      );
                    }
                  });
                  // ???????? ?????????????????? ??????????????????????, ???? ???????????????????????? ???? ???????????? vote.voteId,
                  // ?????? ?????????????????? ???????????????? ??????????????????????, ?????????????????????????????????? ???? ???????????? vote.voteId
                  if (action == 'vote.close') {
                    store.client.closeChannel('vote.${vote.id}');
                  } else if (action == 'vote.reopen') {
                    store.client.initChannel('vote.${vote.id}');
                  }
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(color)
                ),
                child: Text(title.toUpperCase()),
              )
            ]
          )
        );
      }
    );
  }
}