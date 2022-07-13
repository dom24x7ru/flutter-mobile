import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/models/post/reaction.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comment_tile.dart';
import 'package:flutter/material.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({ Key? key, required this.enrichedActivity }) : super(key: key);

  final EnrichedActivity enrichedActivity;

  @override
  Widget build(BuildContext context) {
    final reactions = enrichedActivity.latestReactions!['comment'] as List<Reaction>;
    return ListView.builder(
      itemCount: reactions.length + 1,
      itemBuilder: (context, index) {
        if (index == reactions.length) {
          // Bottom padding to ensure [CommentBox] does not obscure
          // visibility
          return const SizedBox(
            height: 120,
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CommentTile(
            key: ValueKey('comment-${reactions[index].id}'),
            reaction: reactions[index],
          ),
        );
      },
    );
  }
}