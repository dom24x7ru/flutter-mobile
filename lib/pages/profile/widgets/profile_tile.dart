import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/avatar/avatar.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatefulWidget {
  const ProfileTile({
    Key? key,
    required this.user,
    required this.isFollowing,
  }) : super(key: key);

  final IMPerson user;
  final bool isFollowing;

  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
  bool _isLoading = false;
  late bool _isFollowing = widget.isFollowing;

  void followOrUnfollowUser(BuildContext context) {
    setState(() => _isLoading = true);
    if (_isFollowing) {
      // final bloc = FeedProvider.of(context).bloc;
      // await bloc.unfollowFeed(unfolloweeId: widget.user.id);
      _isFollowing = false;
    } else {
      // await FeedProvider.of(context)
      //     .bloc
      //     .followFeed(followeeId: widget.user.id);
      _isFollowing = true;
    }
    // FeedProvider.of(context)
    //     .bloc
    //     .queryEnrichedActivities(
    //   feedGroup: 'timeline',
    //   flags: EnrichmentFlags()
    //     ..withOwnReactions()
    //     ..withRecentReactions()
    //     ..withReactionCounts(),
    // );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Avatar.medium(user: widget.user),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Utilities.getPersonTitle(widget.user.person, widget.user.flat), style: AppTextStyle.textStyleBold),
              Text(Utilities.getFlatTitle(widget.user.flat!), style: AppTextStyle.textStyleFaded),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _isLoading
            ? const CircularProgressIndicator(strokeWidth: 3)
            : OutlinedButton(
              onPressed: () {
                followOrUnfollowUser(context);
              },
            child: _isFollowing
              ? const Text('Unfollow')
              : const Text('Follow'),
          ),
        )
      ],
    );
  }
}