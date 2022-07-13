/// Indicates the type of comment that was made.
/// Can be:
/// - Activity comment
/// - Reaction comment
enum TypeOfComment {
  /// Comment on an activity
  activityComment,

  /// Comment on a reaction
  reactionComment,
}