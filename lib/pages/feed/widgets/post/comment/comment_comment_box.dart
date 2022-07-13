import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comment_focus.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comment_state.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/enum/type_of_comment.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment_box.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/tap_fade_icon.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentCommentBox extends StatefulWidget {
  const CommentCommentBox({
    Key? key,
    required this.enrichedActivity,
  }) : super(key: key);

  final EnrichedActivity enrichedActivity;

  @override
  State<CommentCommentBox> createState() => _CommentCommentBoxState();
}

class _CommentCommentBoxState extends State<CommentCommentBox> {
  late final _commentTextController = TextEditingController();

  Future<void> handleSubmit(String? value) async {
    if (value != null && value.isNotEmpty) {
      _commentTextController.clear();
      FocusScope.of(context).unfocus();

      final commentState = context.read<CommentState>();
      final commentFocus = commentState.commentFocus;

      if (commentFocus.typeOfComment == TypeOfComment.activityComment) {
        // await FeedProvider.of(context).bloc.onAddReaction(
        //   kind: 'comment',
        //   activity: widget.enrichedActivity,
        //   feedGroup: 'timeline',
        //   data: {'message': value},
        // );
      } else if (commentFocus.typeOfComment == TypeOfComment.reactionComment) {
        if (commentFocus.reaction != null) {
          // await FeedProvider.of(context).bloc.onAddChildReaction(
          //   kind: 'comment',
          //   reaction: commentFocus.reaction!,
          //   activity: widget.enrichedActivity,
          //   data: {'message': value},
          // );
        }
      }
    }
  }

  @override
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentFocus = context.select((CommentState state) => state.commentFocus);
    final focusNode = context.watch<FocusNode>();
    final store = Provider.of<MainStore>(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: (Theme.of(context).brightness == Brightness.light)
            ? AppColors.light
            : AppColors.dark,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                final tween =
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeOutQuint));
                final offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              child:
              (commentFocus.typeOfComment == TypeOfComment.reactionComment)
                  ? _replyToBox(commentFocus, context)
                  : const SizedBox.shrink(),
            ),
            CommentBox(
              commenter: store.user.value!.toIMPerson(),
              textEditingController: _commentTextController,
              onSubmitted: handleSubmit,
              focusNode: focusNode,
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Container _replyToBox(CommentFocus commentFocus, BuildContext context) {
    return Container(
      color: (Theme.of(context).brightness == Brightness.dark)
          ? AppColors.grey
          : AppColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              'Replying to ${Utilities.getPersonTitle(commentFocus.user.person, commentFocus.user.flat)}',
              style: AppTextStyle.textStyleFaded,
            ),
            const Spacer(),
            TapFadeIcon(
              onTap: () {
                context.read<CommentState>().resetCommentFocus();
              },
              icon: Icons.close,
              size: 16,
              iconColor: Theme.of(context).iconTheme.color!,
            ),
          ],
        ),
      ),
    );
  }
}