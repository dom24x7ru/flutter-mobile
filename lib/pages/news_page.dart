import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/post.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'flat_page.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    if (!store.loaded) {
      return Scaffold(
        appBar: Header(context, 'Новости'),
        bottomNavigationBar: Footer(context, FooterNav.news)
      );
    }

    return Scaffold(
      appBar: Header(context, 'Новости'),
      bottomNavigationBar: Footer(context, FooterNav.news),
      body: ListView.builder(
        itemCount: store.posts.list!.length,
        itemBuilder: (BuildContext context, int index) {
          final Post post = store.posts.list![index];
          final createdAt = DateFormat('dd.MM.y HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(post.createdAt));
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
        print(post.type);
        return {'icon': Icons.notifications, 'color': Colors.blue};
      }
    }
  }

  void goPage(BuildContext context, Post post, List<Flat> flats) {
    print('${post.type}: ${post.url}');
    if (post.type == 'person') {
      final flatNumber = post.url!.replaceAll('/flat/', '');
      for (var flat in flats) {
        if (flatNumber == flat.number.toString()) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(flat)));
        }
      }
    }
  }
}