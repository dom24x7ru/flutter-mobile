import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({Key? key}) : super(key: key);

  /// MaterialPageRoute to this screen.
  static Route route() => MaterialPageRoute(builder: (context) => const PostCreateScreen());

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.get(context, Utilities.getHeaderTitle('Публикация')),
      body: Container()
    );
  }
}
