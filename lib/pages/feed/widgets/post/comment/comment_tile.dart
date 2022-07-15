import 'package:dom24x7_flutter/models/post/reaction.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/avatar/avatar.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comment_focus.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comment_list_child.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comment_state.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/enum/type_of_comment.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/favorite_icon_button.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentTile extends StatefulWidget {
  const CommentTile({
    Key? key,
    required this.reaction,
    this.canReply = true,
    this.isReplyToComment = false,
  }) : super(key: key);

  final Reaction reaction;
  final bool canReply;
  final bool isReplyToComment;
  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  late final user = widget.reaction.user!;
  late final message = extractMessage;

  late final timeSince = _timeSinceComment();

  late int numberOfLikes = widget.reaction.childrenCounts?['like'] ?? 0;

  late bool isLiked = _isFavorited();
  Reaction? likeReaction;

  String _timeSinceComment() {
    final jiffyTime = Utilities.getDateFromNow(widget.reaction.createdAt);
    if (jiffyTime == 'несколько секунд назад') {
      return 'только что';
    } else {
      return jiffyTime;
    }
  }

  String numberOfLikesMessage(int count) {
    if (count == 0) {
      return '';
    }
    if (count == 1) {
      return '1 like';
    } else {
      return '$count likes';
    }
  }

  String get extractMessage {
    final data = widget.reaction.data;
    if (data != null && data['message'] != null) {
      return data['message'] as String;
    } else {
      return '';
    }
  }

  bool _isFavorited() {
    likeReaction = widget.reaction.ownChildren?['like']?.first;
    return likeReaction != null;
  }

  void _handleFavorite(bool liked) {
    if (isLiked && likeReaction != null) {
      // await context.appState.client.reactions.delete(likeReaction!.id!);
      numberOfLikes--;
    } else {
      // likeReaction = await context.appState.client.reactions.addChild(
      //   'like',
      //   widget.reaction.id!,
      //   userId: context.appState.user.id,
      // );
      numberOfLikes++;
    }
    setState(() => isLiked = liked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: (widget.isReplyToComment)
                  ? Avatar.tiny(user: user)
                  : Avatar.small(user: user),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: Utilities.getPersonTitle(user.person, user.flat),
                                  style: AppTextStyle.textStyleSmallBold),
                              const TextSpan(text: ' '),
                              TextSpan(
                                text: message,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //   child: Center(
                      //     child: FavoriteIconButton(
                      //       isLiked: isLiked,
                      //       size: 14,
                      //       onTap: _handleFavorite,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 90,
                          child: Text(
                            timeSince,
                            style: AppTextStyle.textStyleFadedSmall,
                          ),
                        ),
                        Visibility(
                          visible: numberOfLikes > 0,
                          child: SizedBox(
                            width: 60,
                            child: Text(
                              numberOfLikesMessage(numberOfLikes),
                              style: AppTextStyle.textStyleFadedSmall,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.canReply,
                          child: GestureDetector(
                            onTap: () {
                              context.read<CommentState>().setCommentFocus(
                                CommentFocus(
                                  typeOfComment:
                                  TypeOfComment.reactionComment,
                                  id: widget.reaction.id.toString(),
                                  user: widget.reaction.user!,
                                  reaction: widget.reaction,
                                ),
                              );

                              FocusScope.of(context).requestFocus(context.read<FocusNode>());
                            },
                            child: const SizedBox(
                              width: 60,
                              child: Text(
                                'Ответить',
                                style: AppTextStyle.textStyleFadedSmallBold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 34.0),
          child: ChildCommentList(comments: widget.reaction.latestChildren?['comment']),
        ),
      ],
    );
  }
}