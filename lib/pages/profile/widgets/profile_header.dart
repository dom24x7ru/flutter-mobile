import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/avatar/avatar.dart';
import 'package:dom24x7_flutter/pages/profile/followers_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({ Key? key, required this.numberOfPosts }) : super(key: key);

  final int numberOfPosts;

  static const _statisticsPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8.0);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final user = store.user.value;
    final IMPerson? person = user?.toIMPerson();

    if (user == null) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Avatar.big(user: person!)
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: _statisticsPadding,
                  child: Column(
                    children: [
                      Text('$numberOfPosts', style: AppTextStyle.textStyleBold),
                      const Text('Публикации', style: AppTextStyle.textStyleLight)
                    ],
                  )
                ),
                Padding(
                  padding: _statisticsPadding,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(FollowersPage.route()),
                    child: Column(
                      children: [
                        Text('${user.profile!['followers']}', style: AppTextStyle.textStyleBold),
                        const Text('Подписчики', style: AppTextStyle.textStyleLight),
                      ],
                    )
                  )
                ),
                Padding(
                  padding: _statisticsPadding,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(FollowersPage.route()),
                    child: Column(
                      children: [
                        Text('${user.profile!['following']}', style: AppTextStyle.textStyleBold),
                        const Text('Подписки', style: AppTextStyle.textStyleLight),
                      ],
                    )
                  )
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(Utilities.getPersonTitle(person.person, person.flat), style: AppTextStyle.textStyleBoldMedium)),
        ),
      ],
    );
  }
}