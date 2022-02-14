import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/post.dart';
import 'package:dom24x7_flutter/pages/services/votes/vote_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/vote.dart';
import '../utilities.dart';
import 'flat_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Vote? vote;
  late SocketClient _client;
  final List<dynamic> _listeners = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;

      setState(() { vote = getVote(store); });
      var listener = _client.on('vote', this, (event, cont) {
        setState(() { vote = getVote(store); });
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

    if (!store.loaded || store.posts.list == null) {
      return Scaffold(
          appBar: Header(context, 'Новости'),
          bottomNavigationBar: Footer(context, FooterNav.news)
      );
    }

    final int itemCount = store.posts.list!.length + (vote != null ? 1 : 0);

    return Scaffold(
        appBar: Header(context, 'Новости'),
        bottomNavigationBar: Footer(context, FooterNav.news),
        body: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              if (vote != null && index == 0) {
                // отображаем карточку голосования
                final createdAt = Utilities.getDateFormat(vote!.createdAt);
                return GestureDetector(
                    onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => VotePage(vote!))) },
                    child: Card(
                        color: Colors.green,
                        child: Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(vote!.title.toUpperCase(), style: const TextStyle(color: Colors.white)),
                                  Text(createdAt, style: const TextStyle(color: Colors.white38)),
                                  Container(padding: const EdgeInsets.all(10.0)),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Проголосовало ${vote!.answers.length} из ${vote!.persons}', style: const TextStyle(color: Colors.white)),
                                      ]
                                  )
                                ]
                            )
                        )
                    )
                );
              }

              final Post post = store.posts.list![index + (vote != null ? 1 : 0)];
              final createdAt = Utilities.getDateFormat(post.createdAt);
              final icon = getIconStyle(post);
              return GestureDetector(
                  onTap: () => { goPage(context, post, store.flats.list!) },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(icon['icon'], color: icon['color']),
                        title: Text(
                            post.title.toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.black45
                            )
                        ),
                        subtitle: Text(createdAt),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                        child: Text(post.body),
                      )
                    ],
                  )
              );
            }
        )
    );
  }

  Map<String, dynamic> getIconStyle(Post post) {
    switch (post.type) {
      case 'person': return {'icon': Icons.person, 'color': Colors.green};
      case 'attention': return {'icon': Icons.new_releases_outlined, 'color': Colors.red};
      case 'holiday': return {'icon': Icons.celebration, 'color': Colors.orange};
      case 'app': return {'icon': Icons.notifications, 'color': Colors.orange};
      case 'faq': return {'icon': Icons.lightbulb, 'color': Colors.yellow};
      case 'document': return {'icon': Icons.text_snippet, 'color': Colors.deepPurple};
      case 'news': return {'icon': Icons.notifications, 'color': Colors.blue};
      case 'instruction': return {'icon': Icons.checklist, 'color': Colors.blue};
      default: {
        return {'icon': Icons.notifications, 'color': Colors.blue};
      }
    }
  }

  void goPage(BuildContext context, Post post, List<Flat> flats) {
    if (post.type == 'person') {
      final flatNumber = post.url!.replaceAll('/flat/', '');
      for (var flat in flats) {
        if (flatNumber == flat.number.toString()) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(flat)));
        }
      }
    }
  }

  Vote? getVote(MainStore store) {
    List<Vote>? votes = store.votes.list;
    if (votes == null || votes.isEmpty) return null; // нет доступных голосований
    votes = votes.where((vote) => !vote.closed).toList();
    if (votes.isEmpty) return null; // все голосования уже закрыты
    votes = votes.where((vote) => !answered(store, vote)).toList();
    if (votes.isEmpty) return null; // на все незакрытые голосования уже проголосовал
    return votes[0]; // вернем первое доступное, в котором уже не участвовали
  }

  bool answered(MainStore store, Vote vote) {
    final answers = vote.answers;
    if (answers.isEmpty) return false;

    final person = store.user.value!.person;
    if (person == null) return false;

    return answers.where((answer) => answer.person.id == person.id).isNotEmpty;
  }
}