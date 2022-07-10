import 'package:cached_network_image/cached_network_image.dart';
import 'package:dom24x7_flutter/pages/feed/utils.dart';
import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/favorite_icon_button.dart';
import 'package:dom24x7_flutter/models/post/reaction.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/tap_fade_icon.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';

class PictureCarousal extends StatefulWidget {
  const PictureCarousal({Key? key, required this.enrichedActivity}) : super(key: key);

  final EnrichedActivity enrichedActivity;

  @override
  State<PictureCarousal> createState() => _PictureCarousalState();
}

class _PictureCarousalState extends State<PictureCarousal> {
  late var likeReactions = getLikeReactions() ?? [];
  late var likeCount = getLikeCount() ?? 0;

  Reaction? latestLikeReaction;

  List<Reaction>? getLikeReactions() {
    return widget.enrichedActivity.latestReactions?['like'] ?? [];
  }

  int? getLikeCount() {
    return widget.enrichedActivity.reactionCounts?['like'] ?? 0;
  }

  Future<void> _addLikeReaction() async {
    // FIXME
    // latestLikeReaction = await context.appState.client.reactions.add(
    //   'like',
    //   widget.enrichedActivity.id,
    //   userId: context.appState.user.id,
    // );

    setState(() {
      likeReactions.add(latestLikeReaction!);
      likeCount++;
    });
  }

  Future<void> _removeLikeReaction() async {
    late String? reactionId;
    // A new reaction was added to this state.
    if (latestLikeReaction != null) {
      reactionId = latestLikeReaction?.id.toString();
    } else {
      // An old reaction has been retrieved from Stream.
      final prevReaction = widget.enrichedActivity.ownReactions?['like'];
      if (prevReaction != null && prevReaction.isNotEmpty) {
        reactionId = prevReaction[0].id;
      }
    }

    try {
      if (reactionId != null) {
        // FIXME await context.appState.client.reactions.delete(reactionId);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      likeReactions.removeWhere((element) => element.id.toString() == reactionId);
      likeCount--;
      latestLikeReaction = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._pictureCarousel(context),
        _likes(),
      ],
    );
  }

  /// Picture carousal and interaction buttons.
  List<Widget> _pictureCarousel(BuildContext context) {
    const iconPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
    var imageUrl = widget.enrichedActivity.extraData!['image_url'] as String;
    double aspectRatio = widget.enrichedActivity.extraData!['aspect_ratio'] as double? ?? 1.0;
    final iconColor = Theme.of(context).iconTheme.color!;
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
              ),
            ),
          ),
        ),
      ),
      Row(
        children: [
          const SizedBox(width: 4),
          Padding(
            padding: iconPadding,
            child: FavoriteIconButton(
              isLiked: widget.enrichedActivity.ownReactions?['like'] != null,
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
                // TODO
              },
              icon: Icons.chat_bubble_outline,
              iconColor: iconColor,
            ),
          ),
          Padding(
            padding: iconPadding,
            child: TapFadeIcon(
              onTap: () => context.removeAndShowSnackbar('Message: Not yet implemented'),
              icon: Icons.call_made,
              iconColor: iconColor,
            ),
          ),
          const Spacer(),
          Padding(
            padding: iconPadding,
            child: TapFadeIcon(
              onTap: () => context.removeAndShowSnackbar('Bookmark: Not yet implemented'),
              icon: Icons.bookmark_border,
              iconColor: iconColor,
            ),
          ),
        ],
      )
    ];
  }

  Widget _likes() {
    if (likeReactions.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8),
        child: Text.rich(
          TextSpan(
            text: 'Liked by ',
            style: AppTextStyle.textStyleLight,
            children: <TextSpan>[
              TextSpan(
                text: Utilities.getPersonTitle(likeReactions[0].user!.person!, likeReactions[0].user!.residents[0].flat!),
                style: AppTextStyle.textStyleBold),
              if (likeCount > 1 && likeCount < 3) ...[
                const TextSpan(text: ' and '),
                TextSpan(
                  text: Utilities.getPersonTitle(likeReactions[1].user!.person!, likeReactions[1].user!.residents[0].flat!),
                  style: AppTextStyle.textStyleBold),
              ],
              if (likeCount > 3) ...[
                const TextSpan(text: ' and '),
                const TextSpan(text: 'others', style: AppTextStyle.textStyleBold),
              ],
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}