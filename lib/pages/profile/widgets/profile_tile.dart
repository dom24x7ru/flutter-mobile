import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/models/user/user.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/avatar/avatar.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final store = Provider.of<MainStore>(context, listen: false);
    final data = { 'followingId': widget.user.person.id };
    setState(() => _isLoading = true);
    store.client.socket.emit('social.${_isFollowing ? "unfollow" : "follow"}', data, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data == null || data['status'] != 'OK') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Произошла неизвестная ошибка. Попробуйте позже...'), backgroundColor: Colors.red)
        );
        return;
      }

      _isFollowing = !_isFollowing;
      setState(() => _isLoading = false);
    });
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
              onPressed: () => followOrUnfollowUser(context),
              child: _isFollowing
                ? const Text('Отписаться')
                : const Text('Подписаться'),
            ),
        )
      ],
    );
  }
}