import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/post.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/feed_post_widget.dart';
import 'package:dom24x7_flutter/pages/feed/widgets/feed_vote_widget.dart';
import 'package:dom24x7_flutter/pages/services/votes/vote_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

import '../../models/vote/vote.dart';
import '../../utilities.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Vote? vote;
  late SocketClient _client;
  final List<dynamic> _listeners = [];

  @override
  void initState() {
    super.initState();
    _initDynamicLinks();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;

      _checkNewVersion(context);

      setState(() { vote = _getVote(store); });
      var listener = _client.on('vote', this, (event, cont) {
        setState(() { vote = _getVote(store); });
      });
      _listeners.add(listener);
    });
  }

  @override
  void dispose() {
    for (var listener in _listeners) {
      _client.off(listener);
    }
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

    final int itemCount = store.posts.list!.length + (vote != null ? 1 : 0);

    return Scaffold(
        appBar: Header.get(context, 'Новости'),
        bottomNavigationBar: const Footer(FooterNav.news),
        body: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            if (vote != null && index == 0) {
              // отображаем карточку голосования
              return FeedVote(vote!);
            }

            final Post post = store.posts.list![index + (vote != null ? -1 : 0)];
            return FeedPost(post);
          }
        )
    );
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