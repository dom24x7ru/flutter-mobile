import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/store/documents.dart';
import 'package:dom24x7_flutter/store/faq.dart';
import 'package:dom24x7_flutter/store/flats.dart';
import 'package:dom24x7_flutter/store/im.dart';
import 'package:dom24x7_flutter/store/invites.dart';
import 'package:dom24x7_flutter/store/miniapps.dart';
import 'package:dom24x7_flutter/store/posts.dart';
import 'package:dom24x7_flutter/store/recommendations.dart';
import 'package:dom24x7_flutter/store/user.dart';
import 'package:dom24x7_flutter/store/version.dart';
import 'package:dom24x7_flutter/store/votes.dart';
import 'package:mobx/mobx.dart';

import 'instructions.dart';

part 'main.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  late SocketClient client;

  final version = VersionStore();
  final user = UserStore();
  final flats = FlatsStore();
  final posts = PostsStore();
  final invites = InvitesStore();
  final instructions = InstructionsStore();
  final documents = DocumentsStore();
  final faq = FAQ();
  final recommendations = RecommendationsStore();
  final votes = VotesStore();
  final im = IMStore();
  final miniApps = MiniAppsStore();

  bool loaded = false;

  @action
  void setClient(SocketClient client) {
    this.client = client;
  }

  @action
  void setLoaded(bool status) {
    loaded = status;
  }

  @action
  void clear() {
    version.clear();
    user.clear();
    flats.clear();
    posts.clear();
    invites.clear();
    instructions.clear();
    documents.clear();
    faq.clear();
    recommendations.clear();
    votes.clear();
    im.clear();
    miniApps.clear();

    loaded = false;
  }
}