import 'package:dom24x7_flutter/widgets/checkbox_widget.dart';
import 'package:dom24x7_flutter/models/vote.dart';
import 'package:dom24x7_flutter/pages/services/votes/answered_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../api/socket_client.dart';
import '../../../utilities.dart';
import '../../../widgets/footer_widget.dart';
import '../../../widgets/header_widget.dart';

class Question {
  int id;
  String body;
  bool selected = false;
  Question(this.id, this.body);
}

class VotePage extends StatefulWidget {
  final Vote vote;
  const VotePage(this.vote, {Key? key}) : super(key: key);

  @override
  _VotePageState createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  late List<Question> questions;
  late SocketClient _client;
  final List<dynamic> _listeners = [];

  @override
  void initState() {
    super.initState();
    questions = createQuestionsList(widget.vote);

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;

      var listener = _client.on('vote', this, (event, cont) {
        Map<String, dynamic> eventData = event.eventData as Map<String, dynamic>;
        if (eventData['event'] == 'ready') return;
        final data = eventData['data'];
        final vote = Vote.fromMap(data);
        // если найден наш ответ, то переходим на страницу с результатами
        if (answered(store, vote)) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => VoteAnsweredPage(vote)));
        }
      });
      _listeners.add(listener);
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
    final createdAt = Utilities.getDateFormat(widget.vote.createdAt);

    return Scaffold(
      appBar: Header(context, Utilities.getHeaderTitle(widget.vote.title)),
      bottomNavigationBar: Footer(context, FooterNav.services),
      body: Card(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.vote.title.toUpperCase()),
              Text(createdAt, style: const TextStyle(color: Colors.black26)),
              Container(padding: const EdgeInsets.all(10.0)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Проголосовало ${widget.vote.answers.length} из ${widget.vote.persons}'),
                  ]
              ),
              const Divider(),
              Column(children: questionWidgets(questions)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: btnEnabled() ? () => { send(context, store, widget.vote) } : null,
                    child: Text('Проголосовать'.toUpperCase())
                )
              )
            ]
          )
        )
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

  List<Question> createQuestionsList(Vote vote) {
    return vote.questions.map((question) {
      return Question(question.id, question.body!);
    }).toList();
  }

  List<Widget> questionWidgets(List<Question> questions) {
    return questions.map((question) {
      return Dom24x7Checkbox(
        value: question.selected,
        label: question.body,
        onChanged: (bool? value) => { selectQuestion(widget.vote, question, value) },
      );
    }).toList();
  }

  void selectQuestion(Vote vote, Question question, bool? value) {
    setState(() {
      if (!vote.multi) {
        // необходимо предварительно сбросить все галочки
        for (Question item in questions) {
          item.selected = false;
        }
      }
      question.selected = value!;
    });
  }

  bool btnEnabled() {
    return questions.where((question) => question.selected).isNotEmpty;
  }

  void send(BuildContext context, MainStore store, Vote vote) {
    var data = {
      'voteId': vote.id,
      'answers': questions.where((question) => question.selected).map((question) => question.id).toList()
    };
    store.client.socket.emit('vote.answer', data, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data == null || data['status'] != 'OK') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Не удалось проголосовать. Попробуйте позже'), backgroundColor: Colors.red)
        );
      }
    });
  }
}
