import 'package:dom24x7_flutter/pages/feed/widgets/post/avatar/avatar_widget.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final user = store.user.value;
    if (user == null) {
      return const Icon(Icons.error);
    }
    return Avatar.small(user: user);
  }
}