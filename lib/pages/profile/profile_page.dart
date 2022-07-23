import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/models/post/post.dart';
import 'package:dom24x7_flutter/models/post/reaction.dart';
import 'package:dom24x7_flutter/models/user/im_person.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:dom24x7_flutter/models/user/user.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment_box_wrapper.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/feed_post.dart';
import 'package:dom24x7_flutter/pages/profile/widgets/profile_header.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(builder: (context) => const ProfilePage());

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Post> _posts = [];
  late SocketClient _client;
  final List<dynamic> _listeners = [];
  late User _user;
  late IMPerson _person;

  final ValueNotifier<bool> _showCommentBox = ValueNotifier(false);
  late TextEditingController _commentTextController;
  final FocusNode _commentFocusNode = FocusNode();
  EnrichedActivity? _activeActivity;

  @override
  void initState() {
    super.initState();

    _commentTextController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;
      setState(() {
        _user = store.user.value!;
        _person = _user.toIMPerson();
      });

      setState(() => _posts = _getOwnPosts(store.posts.list, _person.person));
      var listener = _client.on('posts', this, (event, cont) {
        if (!mounted) return;
        setState(() => _posts = _getOwnPosts(store.posts.list, _person.person));
      });
      _listeners.add(listener);

      _client.initChannel('follow.${_user.id}', false);
      listener = _client.on('follow', this, (event, cont) {
        if ((event.eventData as Map)['event'] == 'ready') {
          return;
        }
        final data = (event.eventData as Map)['data'];
        final user = User.fromMap(data);
        store.user.setUser(user);

        if (!mounted) return;
        setState(() {
          _user = user;
          _person = _user.toIMPerson();
        });
      });
    });
  }

  @override
  void dispose() {
    for (var listener in _listeners) {
      _client.off(listener);
    }
    _client.closeChannel('follow.${_user.id}');

    _commentTextController.dispose();
    _commentFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    setState(() {
      _user = store.user.value!;
      _person = _user.toIMPerson();
    });

    return Scaffold(
      appBar: Header.get(context, 'Профиль'),
      bottomNavigationBar: const Footer(null),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          _showCommentBox.value = false;
        },
        child: Stack(
          children: [
            ListView.builder(
              itemCount: _posts.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileHeader(user: _user, numberOfPosts: _posts.length),
                      const Divider(color: Colors.grey)
                    ]
                  );
                }
                return FeedPost(post: _posts[index - 1], onAddComment: _openCommentBox);
              }
            ),
            CommentBoxWrapper(
              commenter: _person,
              textEditingController: _commentTextController,
              focusNode: _commentFocusNode,
              addComment: _addComment,
              showCommentBox: _showCommentBox,
            )
          ]
        )
      )
    );
  }

  void _openCommentBox(EnrichedActivity activity, { String? message }) {
    _commentTextController.text = message ?? '';
    _commentTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentTextController.text.length));
    _activeActivity = activity;
    _showCommentBox.value = true;
    _commentFocusNode.requestFocus();
  }

  void _addComment(String? message) {
    if (_activeActivity != null && message != null && message.isNotEmpty && message != '') {
      _client.socket.emit('post.comment', { 'postId': _activeActivity!.id, 'message': message }, (String name, dynamic error, dynamic data) {
        if (data != null && data['status'] == 'OK') {
          final reactionMap = data['reaction'];
          Reaction reaction = Reaction.fromMap(reactionMap);
          // TODO: обновить данные и визуальную часть

          _commentTextController.clear();
          FocusScope.of(context).unfocus();
          _showCommentBox.value = false;
        }
      });
    }
  }

  List<Post> _getOwnPosts(List<Post>? posts, Person person) {
    if (posts == null || posts.isEmpty) return [];
    return posts.where((post) {
      return post.enrichedActivity!.actor!.person.id == person.id;
    }).toList();
  }
}