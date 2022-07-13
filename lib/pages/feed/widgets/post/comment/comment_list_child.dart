import 'package:dom24x7_flutter/models/post/reaction.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comment_tile.dart';
import 'package:flutter/material.dart';

class ChildCommentList extends StatelessWidget {
  const ChildCommentList({ Key? key, required this.comments }) : super(key: key);

  final List<Reaction>? comments;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: comments
          ?.map(
            (reaction) => Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CommentTile(
            key: ValueKey('comment-tile-${reaction.id}'),
            reaction: reaction,
            canReply: false,
            isReplyToComment: true,
          ),
        ),
      )
          .toList() ??
          [],
    );
  }
}