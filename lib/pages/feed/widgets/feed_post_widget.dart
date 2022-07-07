import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/post.dart';
import 'package:dom24x7_flutter/pages/house/flat_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedPost extends StatefulWidget {
  final Post post;
  const FeedPost(this.post, {Key? key}) : super(key: key);

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  void _goPage(BuildContext context, Post post, List<Flat> flats) {
    if (post.type == 'person') {
      final flatNumber = post.url!.replaceAll('/flat/', '');
      for (var flat in flats) {
        if (flatNumber == flat.number.toString()) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(flat)));
        }
      }
    }
  }

  Map<String, dynamic> _getIconStyle(Post post) {
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

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final createdAt = Utilities.getDateFormat(widget.post.createdAt);
    final icon = _getIconStyle(widget.post);

    return GestureDetector(
      onTap: () => _goPage(context, widget.post, store.flats.list!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(icon['icon'], color: icon['color']),
            title: Text(
              widget.post.title.toUpperCase(),
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
            child: Text(widget.post.body),
          )
        ],
      )
    );
  }
}
