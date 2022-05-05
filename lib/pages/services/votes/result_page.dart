import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/models/vote.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import '../../flat_page.dart';

class VoteResultPage extends StatelessWidget {
  final Vote vote;
  const VoteResultPage(this.vote, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    return Scaffold(
      appBar: Header(context, 'Результаты'),
      bottomNavigationBar: const Footer(FooterNav.services),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: GroupedListView<VoteAnswer, String>(
            elements: vote.answers,
            groupBy: (VoteAnswer answer) => getQuestionBody(vote, answer),
            groupSeparatorBuilder: (String questionBody) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(questionBody, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(questionCount(vote, getQuestionByBody(vote, questionBody)!), style: const TextStyle(fontWeight: FontWeight.bold))
              ]
            ),
            groupComparator: (String group1, String group2) => questionCompare(getQuestionByBody(vote, group1)!, getQuestionByBody(vote, group2)!),
            itemBuilder: (BuildContext context, VoteAnswer answer) {
              return GestureDetector(
                onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(getFlat(store, answer)))) },
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(getPersonOrFlatName(answer), style: const TextStyle(color: Colors.blue))
                )
              );
            },
            useStickyGroupSeparators: true
        )
      )
    );
  }

  String getPersonOrFlatName(VoteAnswer answer) {
    Person person = answer.person;
    String fullName = '';
    if (person.surname != null) {
      fullName += person.surname!;
    }
    if (person.name != null) {
      fullName += ' ${person.name!}';
    }
    if (person.midname != null) {
      fullName += ' ${person.midname!}';
    }
    if (fullName.trim().isEmpty) {
      final flat = answer.flat;
      return 'сосед(ка) из ${Utilities.getFlatTitle(flat)}';
    }
    return fullName.trim();
  }

  String getQuestionBody(Vote vote, VoteAnswer answer) {
    for (VoteQuestion question in vote.questions) {
      if (question.id == answer.question.id) return question.body!;
    }
    return 'Неизвестный вопрос';
  }

  VoteQuestion? getQuestionByBody(Vote vote, String questionBody) {
    for (VoteQuestion question in vote.questions) {
      if (question.body == questionBody) return question;
    }
    return null;
  }

  int questionCompare(VoteQuestion question1, VoteQuestion question2) {
    if (question1.id < question2.id) return -1;
    if (question1.id > question2.id) return 1;
    return 0;
  }

  String questionCount(Vote vote, VoteQuestion question) {
    int count = 0;
    String unit = 'голосов';
    for (VoteAnswer answer in vote.answers) {
      if (answer.question.id == question.id) count++;
    }
    switch (count % 10) {
      case 0:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
        unit = 'голосов';
        break;
      case 1:
        unit = 'голос';
        break;
      case 2:
      case 3:
      case 4:
        unit = 'голоса';
        break;
    }
    if (10 < count && count < 20) unit = 'голосов';
    return '$count $unit';
  }

  Flat getFlat(MainStore store, VoteAnswer answer) {
    Flat flat = answer.flat;
    final flats = store.flats.list!;
    for (Flat item in flats) {
      if (item.id == flat.id) return item;
    }
    return flat;
  }
}
