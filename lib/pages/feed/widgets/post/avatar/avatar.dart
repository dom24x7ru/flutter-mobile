import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/avatar/circular_profile_picture.dart';
import 'package:flutter/material.dart';

/// An avatar that displays a user's profile picture.
///
/// Supports different sizes:
/// - `Avatar.tiny`
/// - `Avatar.small`
/// - `Avatar.medium`
/// - `Avatar.big`
/// - `Avatar.huge`
class Avatar extends StatelessWidget {
  /// Creates a tiny avatar.
  const Avatar.tiny({Key? key, required this.user})
      : _avatarSize = _tinyAvatarSize,
        _coloredCircle = _tinyColoredCircle,
        hasNewStory = false,
        fontSize = 12,
        isThumbnail = true,
        super(key: key);

  /// Creates a small avatar.
  const Avatar.small({Key? key, required this.user})
      : _avatarSize = _smallAvatarSize,
        _coloredCircle = _smallColoredCircle,
        hasNewStory = false,
        fontSize = 14,
        isThumbnail = true,
        super(key: key);

  /// Creates a medium avatar.
  const Avatar.medium({Key? key, this.hasNewStory = false, required this.user})
      : _avatarSize = _mediumAvatarSize,
        _coloredCircle = _mediumColoredCircle,
        fontSize = 20,
        isThumbnail = true,
        super(key: key);

  /// Creates a big avatar.
  const Avatar.big({Key? key, this.hasNewStory = false, required this.user})
      : _avatarSize = _largeAvatarSize,
        _coloredCircle = _largeColoredCircle,
        fontSize = 26,
        isThumbnail = false,
        super(key: key);

  /// Creates a huge avatar.
  const Avatar.huge({Key? key, this.hasNewStory = false, required this.user})
      : _avatarSize = _hugeAvatarSize,
        _coloredCircle = _hugeColoredCircle,
        fontSize = 30,
        isThumbnail = false,
        super(key: key);

  /// Indicates if the user has a new story. If yes, their avatar is surrounded
  /// with an indicator.
  final bool hasNewStory;

  /// The user data to show for the avatar.
  final IMPerson user;

  /// Text size of the user's initials when there is no profile photo.
  final double fontSize;

  final double _avatarSize;
  final double _coloredCircle;

  // Small avatar configuration
  static const _tinyAvatarSize = 22.0;
  static const _tinyPaddedCircle = _tinyAvatarSize + 2;
  static const _tinyColoredCircle = _tinyPaddedCircle * 2 + 4;

  // Small avatar configuration
  static const _smallAvatarSize = 30.0;
  static const _smallPaddedCircle = _smallAvatarSize + 2;
  static const _smallColoredCircle = _smallPaddedCircle * 2 + 4;

  // Medium avatar configuration
  static const _mediumAvatarSize = 40.0;
  static const _mediumPaddedCircle = _mediumAvatarSize + 2;
  static const _mediumColoredCircle = _mediumPaddedCircle * 2 + 4;

  // Large avatar configuration
  static const _largeAvatarSize = 90.0;
  static const _largePaddedCircle = _largeAvatarSize + 2;
  static const _largeColoredCircle = _largePaddedCircle * 2 + 4;

  // Huge avatar configuration
  static const _hugeAvatarSize = 120.0;
  static const _hugePaddedCircle = _hugeAvatarSize + 2;
  static const _hugeColoredCircle = _hugePaddedCircle * 2 + 4;

  /// Whether this avatar uses a thumbnail as an image (low quality).
  final bool isThumbnail;

  @override
  Widget build(BuildContext context) {
    final picture = CircularProfilePicture(
      size: _avatarSize,
      user: user,
      fontSize: fontSize,
      isThumbnail: isThumbnail,
    );

    if (!hasNewStory) {
      return picture;
    }
    return Container(
      width: _coloredCircle,
      height: _coloredCircle,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(child: picture),
    );
  }
}