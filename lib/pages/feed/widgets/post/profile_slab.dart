import 'package:dom24x7_flutter/models/user/user.dart';
import 'package:dom24x7_flutter/pages/feed/utils.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/avatar/avatar.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/tap_fade_icon.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';

class ProfileSlab extends StatelessWidget {
  final User user;
  const ProfileSlab({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      child: Row(
        children: [
          Avatar.medium(user: user),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(Utilities.getPersonTitle(user.person!, user.residents[0].flat!), style: AppTextStyle.textStyleBold)
          ),
          const Spacer(),
          TapFadeIcon(
            onTap: () => context.removeAndShowSnackbar('Not part of the demo'),
            icon: Icons.more_vert,
            iconColor: Theme.of(context).iconTheme.color!,
          ),
        ],
      ),
    );
  }
}