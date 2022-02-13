import 'package:dom24x7_flutter/components/checkbox_component.dart';
import 'package:dom24x7_flutter/models/vote.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    questions = createQuestionsList(widget.vote);
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

    });
  }
}
