import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/post/enriched_activity.dart';
import 'package:dom24x7_flutter/models/post/post.dart';
import 'package:dom24x7_flutter/models/post/reaction.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/comment_box_wrapper.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/feed_post.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/feed_vote.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/post_create_screen.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/post/profile_picture.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/theme.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

import '../../models/vote/vote.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Vote? _vote;
  List<Post> _posts = [];
  late SocketClient _client;
  final List<dynamic> _listeners = [];

  final ValueNotifier<bool> _showCommentBox = ValueNotifier(false);
  late TextEditingController _commentTextController;
  final FocusNode _commentFocusNode = FocusNode();
  EnrichedActivity? _activeActivity;

  @override
  void initState() {
    super.initState();
    _initDynamicLinks();

    _commentTextController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;

      _checkNewVersion(context);

      setState(() => _vote = _getVote(store));
      var listener = _client.on('vote', this, (event, cont) {
        setState(() => _vote = _getVote(store));
      });
      _listeners.add(listener);

      setState(() => _posts = store.posts.list != null ? store.posts.list! : []);
      listener = _client.on('posts', this, (event, cont) {
        setState(() => _posts = store.posts.list != null ? store.posts.list! : []);
      });
      _listeners.add(listener);
    });
  }

  @override
  void dispose() {
    for (var listener in _listeners) {
      _client.off(listener);
    }

    _commentTextController.dispose();
    _commentFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);

    if (!store.loaded || store.posts.list == null) {
      return Scaffold(
        appBar: Header.get(context, 'Новости'),
        bottomNavigationBar: const Footer(FooterNav.news)
      );
    }

    final int itemCount = _posts.length + (_vote != null ? 2 : 1);

    return Scaffold(
      appBar: Header.get(context, 'Новости'),
      bottomNavigationBar: const Footer(FooterNav.news),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          _showCommentBox.value = false;
        },
        child: Stack(
          children: [
            ListView.builder(
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  // отобразить поле ввода поста
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).push(PostCreateScreen.route()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ProfilePicture.medium(),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: _border(context),
                              child: const Text('Что у вас нового?', style: TextStyle(color: Colors.grey))
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      )
                    ),
                  );
                }

                if (_vote != null && index == 1) {
                  // отображаем карточку голосования
                  return FeedVote(_vote!);
                }

                final Post post = _posts[index + (_vote != null ? -2 : -1)];
                return FeedPost(post: post, onAddComment: _openCommentBox);
              }
            ),
            CommentBoxWrapper(
              commenter: store.user.value!.toIMPerson(),
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

  BoxDecoration _border(BuildContext context) {
    return BoxDecoration(
      border: Border.all(color: AppColors.grey.withOpacity(0.3)),
      borderRadius: const BorderRadius.all(Radius.circular(24)),
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

  Future<void> _initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      Navigator.pushNamedAndRemoveUntil(context, dynamicLinkData.link.path, (route) => false);
    }).onError((error) {
      debugPrint('onLink error');
      debugPrint(error.message);
    });
  }

  Vote? _getVote(MainStore store) {
    List<Vote>? votes = store.votes.list;
    if (votes == null || votes.isEmpty) return null; // нет доступных голосований
    votes = votes.where((vote) => !vote.closed).toList();
    if (votes.isEmpty) return null; // все голосования уже закрыты
    votes = votes.where((vote) => !_answered(store, vote)).toList();
    if (votes.isEmpty) return null; // на все незакрытые голосования уже проголосовал
    return votes[0]; // вернем первое доступное, в котором уже не участвовали
  }

  bool _answered(MainStore store, Vote vote) {
    final answers = vote.answers;
    if (answers.isEmpty) return false;

    final person = store.user.value!.person;
    if (person == null) return false;

    return answers.where((answer) => answer.person.id == person.id).isNotEmpty;
  }

  void _checkNewVersion(BuildContext context) async {
    final newVersion = NewVersion(
      iOSAppStoreCountry: 'ru',
      iOSId: 'ru.dom24x7.flutter',
      androidId: 'ru.dom24x7.flutter'
    );
    final status = await newVersion.getVersionStatus();
    if (status != null && status.canUpdate) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Доступно обновление',
        dialogText: 'Вы можете обновить приложение с ${status.localVersion} до ${status.storeVersion}',
        updateButtonText: 'Обновить',
        dismissButtonText: 'Позже'
      );
    }
  }
}