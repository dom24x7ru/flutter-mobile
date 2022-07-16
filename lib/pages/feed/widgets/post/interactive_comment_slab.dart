import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comments_screen.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/on_add_comment.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/profile_picture.dart';
import 'package:dom24x7_flutter/models/post/reaction.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';

class InteractiveCommentSlab extends StatefulWidget {
  const InteractiveCommentSlab({Key? key, required this.enrichedActivity, required this.onAddComment}) : super(key: key);

  final EnrichedActivity enrichedActivity;
  final OnAddComment onAddComment;

  @override
  State<InteractiveCommentSlab> createState() => _InteractiveCommentSlabState();
}

class _InteractiveCommentSlabState extends State<InteractiveCommentSlab> {
  EnrichedActivity get enrichedActivity => widget.enrichedActivity;

  List<Reaction> get _commentReactions => enrichedActivity.latestReactions?['comment'] ?? [];

  int get _commentCount => enrichedActivity.reactionCounts?['comment'] ?? 0;

  @override
  Widget build(BuildContext context) {
    final String timeSinceMessage = Utilities.getDateIM(widget.enrichedActivity.time);
    const textPadding = EdgeInsets.all(8);
    const spacePadding = EdgeInsets.only(left: 20.0, top: 8);
    final comments = _commentReactions;
    final commentCount = _commentCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (commentCount > 0 && comments.isNotEmpty)
          Padding(
            padding: spacePadding,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: Utilities.getPersonTitle(comments[0].user!.person, comments[0].user!.flat),
                    style: AppTextStyle.textStyleBold),
                  const TextSpan(text: '  '),
                  TextSpan(text: comments[0].data?['message'] as String?),
                ],
              ),
            ),
          ),
        if (commentCount > 1 && comments.isNotEmpty)
          Padding(
            padding: spacePadding,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: Utilities.getPersonTitle(comments[1].user!.person, comments[1].user!.flat),
                    style: AppTextStyle.textStyleBold),
                  const TextSpan(text: '  '),
                  TextSpan(text: comments[1].data?['message'] as String?),
                ],
              ),
            ),
          ),
        if (commentCount > 2)
          Padding(
            padding: spacePadding,
            child: GestureDetector(
              onTap: () {
                final actor = widget.enrichedActivity.actor!;
                Navigator.of(context).push(CommentsScreen.route(
                  enrichedActivity: widget.enrichedActivity,
                  activityOwnerData: actor,
                ));
              },
              child: Text(
                'Смотреть все комментарии ($commentCount)',
                style: AppTextStyle.textStyleFaded,
              ),
            ),
          ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => widget.onAddComment(enrichedActivity),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 3, right: 8),
            child: Row(
              children: [
                const ProfilePicture(),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Добавить комментарий...',
                      style: TextStyle(
                        color: AppColors.faded,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.onAddComment(enrichedActivity, message: '❤️'),
                  child: const Padding(
                    padding: textPadding,
                    child: Text('❤️'),
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.onAddComment(enrichedActivity, message: '🙌'),
                  child: const Padding(
                    padding: textPadding,
                    child: Text('🙌'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 4),
          child: Text(
            timeSinceMessage,
            style: const TextStyle(
              color: AppColors.faded,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}