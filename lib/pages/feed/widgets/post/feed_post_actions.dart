import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/models/post/reaction.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comments_screen.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/favorite_icon_button.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/tap_fade_icon.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedPostActions extends StatefulWidget {
  const FeedPostActions({Key? key, required this.enrichedActivity}) : super(key: key);

  final EnrichedActivity enrichedActivity;

  @override
  State<FeedPostActions> createState() => _FeedPostActionsState();
}

class _FeedPostActionsState extends State<FeedPostActions> {
  late var likeReactions = getLikeReactions() ?? [];
  late var likeCount = getLikeCount() ?? 0;
  late var ownLikeReactions = widget.enrichedActivity.ownReactions?['like'] ?? [];

  Reaction? latestLikeReaction;

  late SocketClient _client;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;
    });
  }

  List<Reaction>? getLikeReactions() {
    return widget.enrichedActivity.latestReactions?['like'] ?? [];
  }

  int? getLikeCount() {
    return widget.enrichedActivity.reactionCounts?['like'] ?? 0;
  }

  void _addLikeReaction() {
    _client.socket.emit('post.like', { 'postId': widget.enrichedActivity.id }, (String name, dynamic error, dynamic data) {
      if (data != null && data['status'] == 'OK') {
        latestLikeReaction = Reaction.fromMap(data['reaction']);
        setState(() {
          likeReactions.add(latestLikeReaction!);
          ownLikeReactions = [latestLikeReaction!];
          likeCount++;
        });
      }
    });
  }

  void _removeLikeReaction() {
    String reactionId = ownLikeReactions[0].id.toString();
    _client.socket.emit('post.unlike', { 'postId': widget.enrichedActivity.id }, (String name, dynamic error, dynamic data) {
      if (data != null && data['status'] == 'OK') {
        setState(() {
          likeReactions.removeWhere((reaction) => reaction.id.toString() == reactionId);
          likeCount--;
          latestLikeReaction = null;
          ownLikeReactions = [];
        });
      }
    });
  }

  Widget _likes() {
    if (likeReactions.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8),
        child: Text.rich(
          TextSpan(
            text: 'Нравится: ',
            style: AppTextStyle.textStyleLight,
            children: [
              TextSpan(
                text: Utilities.getPersonTitle(likeReactions[0].user!.person, likeReactions[0].user!.flat),
                style: AppTextStyle.textStyleBold),
              if (likeCount > 1 && likeCount < 3) ...[
                const TextSpan(text: ' и '),
                TextSpan(
                  text: Utilities.getPersonTitle(likeReactions[1].user!.person, likeReactions[1].user!.flat),
                  style: AppTextStyle.textStyleBold),
              ],
              if (likeCount >= 3) ...[
                const TextSpan(text: ' и '),
                const TextSpan(text: 'другим', style: AppTextStyle.textStyleBold),
              ],
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    const iconPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    final iconColor = Theme.of(context).iconTheme.color!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 4),
            Padding(
              padding: iconPadding,
              child: FavoriteIconButton(
                isLiked: ownLikeReactions.isNotEmpty,
                onTap: (liked) {
                  if (liked) {
                    _addLikeReaction();
                  } else {
                    _removeLikeReaction();
                  }
                },
              ),
            ),
            Padding(
              padding: iconPadding,
              child: TapFadeIcon(
                onTap: () {
                  final actor = widget.enrichedActivity.actor!;
                  Navigator.of(context).push(
                    CommentsScreen.route(
                      enrichedActivity: widget.enrichedActivity,
                      activityOwnerData: actor,
                    ),
                  );
                },
                icon: Icons.chat_bubble_outline,
                iconColor: iconColor,
              ),
            ),
            // Padding(
            //   padding: iconPadding,
            //   child: TapFadeIcon(
            //     onTap: () => context.removeAndShowSnackbar('Message: Not yet implemented'),
            //     icon: Icons.call_made,
            //     iconColor: iconColor,
            //   ),
            // ),
            // const Spacer(),
            // Padding(
            //   padding: iconPadding,
            //   child: TapFadeIcon(
            //     onTap: () => context.removeAndShowSnackbar('Bookmark: Not yet implemented'),
            //     icon: Icons.bookmark_border,
            //     iconColor: iconColor,
            //   ),
            // )
          ],
        ),
        _likes()
      ]
    );
  }
}
