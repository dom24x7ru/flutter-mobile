import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/pages/profile/widgets/profile_tile.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({ Key? key, required this.user }) : super(key: key);

  final IMPerson user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final bool _isFollowing = true;

  @override
  Widget build(BuildContext context) {
    return ProfileTile(
      user: widget.user,
      isFollowing: _isFollowing,
    );
  }
}