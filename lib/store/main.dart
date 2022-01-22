import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/store/flats.dart';
import 'package:dom24x7_flutter/store/invites.dart';
import 'package:dom24x7_flutter/store/posts.dart';
import 'package:dom24x7_flutter/store/user.dart';
import 'package:dom24x7_flutter/store/version.dart';
import 'package:mobx/mobx.dart';

part 'main.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  late SocketClient client;

  final version = VersionStore();
  final user = UserStore();
  final flats = FlatsStore();
  final posts = PostsStore();
  final invites = InvitesStore();

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

    loaded = false;
  }
}