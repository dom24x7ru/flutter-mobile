import 'package:dom24x7_flutter/models/post/post.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/feed_post_description.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/picture/picture_carousal.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/profile_slab.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedPost extends StatefulWidget {
  final Post post;
  const FeedPost(this.post, {Key? key}) : super(key: key);

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    List<Widget> widgets = [ProfileSlab(user: store.user.value!)];
    if (widget.post.enrichedActivity != null) {
      widgets.add(PictureCarousal(enrichedActivity: widget.post.enrichedActivity!));
      widgets.add(Description(enrichedActivity: widget.post.enrichedActivity!));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets
    );
  }
}
