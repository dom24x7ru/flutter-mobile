import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/models/post/post.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/feed_post_description.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/interactive_comment_slab.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/picture/picture_carousal.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/profile_slab.dart';
import 'package:flutter/material.dart';

typedef OnAddComment = void Function(EnrichedActivity activity, { String? message });

class FeedPost extends StatefulWidget {
  const FeedPost({Key? key, required this.post, required this.onAddComment,}) : super(key: key);

  final Post post;
  final OnAddComment onAddComment;

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
      if (enrichedActivity.extraData!['image_url'] != null) widgets.add(PictureCarousal(enrichedActivity: enrichedActivity));
      widgets.add(Description(enrichedActivity: enrichedActivity));
      widgets.add(InteractiveCommentSlab(
        enrichedActivity: enrichedActivity,
        onAddComment: widget.onAddComment
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets
    );
  }
}
