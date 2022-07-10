import 'package:dom24x7_flutter/models/post/post.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/feed_post_description.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/picture/picture_carousal.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/profile_slab.dart';
import 'package:flutter/material.dart';

class FeedPost extends StatefulWidget {
  final Post post;
  const FeedPost(this.post, {Key? key}) : super(key: key);

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [ProfileSlab(user: widget.post.enrichedActivity!.actor!)];
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
