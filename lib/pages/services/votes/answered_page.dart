import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/models/vote.dart';
import 'package:dom24x7_flutter/pages/services/votes/result_page.dart';
import 'package:dom24x7_flutter/pages/services/votes/vote_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoteResultFormat {
  String text;
  String value;

  VoteResultFormat(this.text, this.value);
}

class VoteAnsweredPage extends StatefulWidget {
  final Vote vote;
  const VoteAnsweredPage(this.vote, {Key? key}) : super(key: key);

  @override
  _VoteAnsweredPageState createState() => _VoteAnsweredPageState();
}

class _VoteAnsweredPageState extends State<VoteAnsweredPage> {
  List<VoteResultFormat> voteResultFormats = [
    VoteResultFormat('По жильцам', 'persons'),
    VoteResultFormat('По квартирам', 'flats'),
    VoteResultFormat('По квадратуре', 'squares')
  ];
  late VoteResultFormat voteResultFormat = voteResultFormats[0];

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    final createdAt = Utilities.getDateFormat(widget.vote.createdAt);
    final List<Widget> status = [];
    if (answered(store, widget.vote)) status.add(const Icon(Icons.done, color: Colors.green, size: 15.0));
    if (widget.vote.closed) status.add(const Icon(Icons.block, color: Colors.red, size: 15.0));

    return Scaffold(
        appBar: Header(context, Utilities.getHeaderTitle(widget.vote.title)),
        bottomNavigationBar: const Footer(FooterNav.services),
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
                            Row(mainAxisAlignment: MainAxisAlignment.end, children: status)
                          ]
                      ),
                      const Divider(),
                      DropdownButton<VoteResultFormat>(
                        isExpanded: true,
                        value: voteResultFormat,
                        onChanged: (VoteResultFormat? value) {
                          setState(() {
                            voteResultFormat = value!;
                          });
                        },
                        items: voteResultFormats.map<DropdownMenuItem<VoteResultFormat>>((VoteResultFormat value) {
                          return DropdownMenuItem<VoteResultFormat>(
                            value: value,
                            child: Text(value.text)
                          );
                        }).toList(),
                      ),
                      resultChart(store, widget.vote)
                    ]
                )
            )
        )
    );
  }

  bool answered(MainStore store, Vote vote, [VoteQuestion? question]) {
    final answers = vote.answers;
    if (answers.isEmpty) return false;

    final person = store.user.value!.person;
    if (person == null) return false;

    final personAnswers = answers.where((answer) => answer.person.id == person.id).toList();
    if (question == null) return personAnswers.isNotEmpty;

    for (VoteAnswer answer in personAnswers) {
      if (answer.question.id == question.id) return true;
    }

    return false;
  }
  
  Widget resultChart(MainStore store, Vote vote) {
    List<TableRow> rows = [];
    for (VoteQuestion question in vote.questions) {
      double percent = this.percent(store, vote, question);
      rows.add(
        TableRow(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${Utilities.percent(percent)} '),
              ]
            ),
            Text(question.body!)
          ]
        )
      );
      rows.add(
        TableRow(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                answered(store, vote, question) ? const Icon(Icons.task_alt, color: Colors.blue, size: 16.0) : const Text(''),
                const Text(' ')
              ]
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: LinearProgressIndicator(value: percent)
            )
          ]
        )
      );
    }
    return GestureDetector(
      child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(0.2),
            1: FlexColumnWidth()
          },
          children: rows
      ),
      onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => VoteResultPage(vote))) },
      onLongPress: () => { showMenu(context, store, vote) }
    );
  }

  double percent(MainStore store, Vote vote, VoteQuestion question) {
    switch (voteResultFormat.value) {
      case 'persons': return percentPersons(vote, question);
      case 'flats': return percentFlats(store, vote, question);
      case 'squares': return percentSquares(store, vote, question);
      default: return percentPersons(vote, question);
    }
  }

  double percentPersons(Vote vote, VoteQuestion question) {
    List<VoteAnswer> answers = vote.answers.where((answer) => answer.question.id == question.id).toList();
    return answers.length / vote.persons;
  }

  double percentFlats(MainStore store, Vote vote, VoteQuestion question) {
    List<VoteAnswer> answers = vote.answers.where((answer) => answer.question.id == question.id).toList();
    int uniqueFlatsCount = 0;
    Map<int, List<Person>> flats = {};
    for (VoteAnswer answer in answers) {
      final flat = answer.flat;
      if (flats[flat.id] == null) {
        flats[flat.id] = [];
        uniqueFlatsCount++;
      }
      flats[flat.id]!.add(answer.person);
    }

    return uniqueFlatsCount / getVoteFlats(store, vote).length;
  }

  double percentSquares(MainStore store, Vote vote, VoteQuestion question) {
    List<VoteAnswer> answers = vote.answers.where((answer) => answer.question.id == question.id).toList();
    double uniqueFlatsSquares = 0;
    Map<int, List<Person>> flats = {};
    for (VoteAnswer answer in answers) {
      final flat = answer.flat;
      if (flats[flat.id] == null) {
        flats[flat.id] = [];
        uniqueFlatsSquares += flat.square;
      }
      flats[flat.id]!.add(answer.person);
    }

    final squares = getVoteFlats(store, vote).map((Flat flat) => flat.square).reduce((sum, square) => sum + square);
    return uniqueFlatsSquares / squares;
  }

  List<Flat> getVoteFlats(MainStore store, Vote vote) {
    List<Flat> voteFlats = store.flats.list!;
    if (vote.section != null) {
      voteFlats = voteFlats.where((flat) => flat.section == vote.section).toList();
    }
    if (vote.floor != null) {
      voteFlats = voteFlats.where((flat) => (flat.section == vote.section && flat.floor == vote.floor)).toList();
    }
    return voteFlats;
  }

  void showMenu(BuildContext context, MainStore store, Vote vote) {
    if (vote.closed) return;
    
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
                  store.client.socket.emit('vote.cancelAnswer', { 'voteId': vote.id }, (String name, dynamic error, dynamic data) {
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
                      );
                      return;
                    }
                    if (data == null || data['status'] != 'OK') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Не удалось отменить голос. Попробуйте позже'), backgroundColor: Colors.red)
                      );
                      return;
                    }

                    Navigator.push(context, MaterialPageRoute(builder: (context) => VotePage(vote)));
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)
                ),
                child: Text('Отменить голос'.toUpperCase()),
              )
            ]
          )
        );
      }
    );
  }
}