import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/comment_focus.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/enum/type_of_comment.dart';
import 'package:flutter/material.dart';

/// {@template comment_state}
/// ChangeNotifier to facilitate posting comments to activities and reactions.
/// {@endtemplate}
class CommentState extends ChangeNotifier {
  /// {@macro comment_state}
  CommentState({
    required this.activityId,
    required this.activityOwnerData,
  });

  /// The id for this activity.
  final String activityId;

  /// UserData of whoever owns the activity.
  final IMPerson activityOwnerData;

  /// The type of commentFocus that is currently selected.
  late CommentFocus commentFocus = CommentFocus(
    typeOfComment: TypeOfComment.activityComment,
    id: activityId,
    user: activityOwnerData,
  );

  /// Sets the focus to which a comment will be posted to.
  ///
  /// See [postComment].
  void setCommentFocus(CommentFocus focus) {
    commentFocus = focus;
    notifyListeners();
  }

  /// Resets the comment focus to the parent activity.
  void resetCommentFocus() {
    commentFocus = CommentFocus(
      typeOfComment: TypeOfComment.activityComment,
      id: activityId,
      user: activityOwnerData,
    );
    notifyListeners();
  }
}