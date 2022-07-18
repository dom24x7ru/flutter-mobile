import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class FollowersPage extends StatefulWidget {
  const FollowersPage({Key? key}) : super(key: key);

  /// MaterialPageRoute to this screen.
  static Route route() => MaterialPageRoute(builder: (context) => const FollowersPage());

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.get(context, Utilities.getHeaderTitle('Подписчики')),
      body: Container()
    );
  }
}
