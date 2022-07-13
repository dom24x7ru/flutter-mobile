import 'package:dom24x7_flutter/models/post/reaction.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment/enum/type_of_comment.dart';

/// {@template comment_focus}
/// Information on the type of comment to make. This can be a comment on an
/// activity, or a comment on a reaction.
///
/// It also indicates the parent user on whom the comment is made.
/// {@endtemplate}
class CommentFocus {
  /// {@macro comment_focus}
  const CommentFocus({
    required this.typeOfComment,
    required this.id,
    required this.user,
    this.reaction,
  });

  final Reaction? reaction;

  /// Indicates the type of comment. See [TypeOfComment].
  final TypeOfComment typeOfComment;

  /// Activity or reaction id on which the comment is made.
  final String id;

  /// The user data of the parent activity or reaction.
  final IMPerson user;
}