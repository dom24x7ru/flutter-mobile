import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
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
    List<Widget> widgets = [];
    if (widget.post.enrichedActivity != null) {
      EnrichedActivity enrichedActivity = widget.post.enrichedActivity!;
      if (enrichedActivity.actor != null) widgets.add(ProfileSlab(user: enrichedActivity.actor!));
      widgets.add(PictureCarousal(enrichedActivity: enrichedActivity));
      widgets.add(Description(enrichedActivity: enrichedActivity));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets
    );
  }
}
