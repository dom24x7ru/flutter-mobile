import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/avatar/avatar.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key}) : _avatarSize = 'small', super(key: key);
  const ProfilePicture.medium({Key? key}) : _avatarSize = 'medium', super(key: key);

  final String _avatarSize;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final user = store.user.value;
    if (user == null) {
      return const Icon(Icons.error);
    }
    IMPerson person = IMPerson(
        user.person!,
        user.residents[0].flat!,
        null,
        null
    );
    return _avatarSize == 'small' ? Avatar.small(user: person) : Avatar.medium(user: person);
  }
}