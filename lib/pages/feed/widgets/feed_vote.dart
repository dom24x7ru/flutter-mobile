import 'package:dom24x7_flutter/models/vote/vote.dart';
import 'package:dom24x7_flutter/pages/services/votes/vote_page.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';

class FeedVote extends StatefulWidget {
  final Vote vote;
  const FeedVote(this.vote, {Key? key}) : super(key: key);

  @override
  State<FeedVote> createState() => _FeedVoteState();
}

class _FeedVoteState extends State<FeedVote> {
  @override
  Widget build(BuildContext context) {
    final createdAt = Utilities.getDateFormat(widget.vote.createdAt);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VotePage(widget.vote))),
      child: Card(
        color: Colors.green,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.vote.title.toUpperCase(), style: const TextStyle(color: Colors.white)),
              Text(createdAt, style: const TextStyle(color: Colors.white38)),
              Container(padding: const EdgeInsets.all(10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Проголосовало ${widget.vote.answers.length} из ${widget.vote.persons}', style: const TextStyle(color: Colors.white)),
                ]
              )
            ]
          )
        )
      )
    );
  }
}
