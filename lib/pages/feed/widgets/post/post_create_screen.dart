import 'package:dom24x7_flutter/pages/feed/widgets/post/profile_picture.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({Key? key}) : super(key: key);

  /// MaterialPageRoute to this screen.
  static Route route() => MaterialPageRoute(builder: (context) => const PostCreateScreen());

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  late TextEditingController _cBody;
  bool _btnEnabled = false;

  @override
  void initState() {
    super.initState();
    _cBody = TextEditingController();
  }

  @override
  void dispose() {
    _cBody.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final user = store.user.value!.toIMPerson();

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Text(Utilities.getHeaderTitle('Публикация'))]),
        actions: [
          IconButton(onPressed: _btnEnabled ? _save : null, icon: const Icon(Icons.check))
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const ProfilePicture.medium(),
            title: Text(Utilities.getPersonTitle(user.person, user.flat), style: AppTextStyle.textStyleBold)
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _cBody,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (String value) => _calcBtnEnabled(),
              decoration: const InputDecoration.collapsed(
                hintText: 'Что у вас нового?'
              )
            )
          )
        ]
      )
    );
  }

  void _calcBtnEnabled() {
    setState(() => _btnEnabled = _cBody.text.trim().isNotEmpty);
  }

  void _save() {
    final body = _cBody.text;
    if (body.isEmpty || body.trim() == '') return;
    final store = Provider.of<MainStore>(context, listen: false);
    final data = { 'id': null, 'body': body };
    store.client.socket.emit('post.save', data, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      Navigator.pop(context);
    });
  }
}
