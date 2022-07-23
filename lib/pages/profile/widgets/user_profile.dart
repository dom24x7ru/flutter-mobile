import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/pages/profile/widgets/profile_tile.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({ Key? key, required this.user, required this.isFollowing }) : super(key: key);

  final IMPerson user;
  final bool isFollowing;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final bool _isFollowing = true;

  @override
  Widget build(BuildContext context) {
    return ProfileTile(
      user: widget.user,
      isFollowing: widget.isFollowing,
    );
  }
}