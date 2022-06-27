import 'dart:async';
import 'dart:io';

import 'package:dom24x7_flutter/models/document.dart';
import 'package:dom24x7_flutter/models/faq_item.dart';
import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/im/im_channel.dart';
import 'package:dom24x7_flutter/models/instruction.dart';
import 'package:dom24x7_flutter/models/house/invite.dart';
import 'package:dom24x7_flutter/models/miniapp.dart';
import 'package:dom24x7_flutter/models/mutual_help_item.dart';
import 'package:dom24x7_flutter/models/post.dart';
import 'package:dom24x7_flutter/models/recommendation.dart';
import 'package:dom24x7_flutter/models/user/user.dart';
import 'package:dom24x7_flutter/models/vote.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:eventify/eventify.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socketcluster_client/socketcluster_client.dart';

class SocketClient extends BasicListener with EventEmitter {
  late Socket socket;
  late String url;
  MainStore store;
  User? user;
  List<String> channels = [];
  Timer? _timer;

  BoxCollection? _hiveCollection;
  Box? _box;

  final ready = {
    'house': true,
    'flats': false,
    'posts': false,
    'pinnedPosts': true,
    'instructions': true,
    'invites': true, // для запуска приложения, не обязательно дожидаться
    'documents': true,
    'faq': true,
    'recommendations': true,
    'mutualHelp': true,
    'votes': true,
    'imChannels': true,
  };

  SocketClient(this.store);

  Future<void> connect([String url = 'node.dom24x7.ru']) async {
    try {
      _box ??= await Hive.openBox('dom24x7');

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      String? lastNodeHost = prefs.getString('lastNodeHost');
      this.url = lastNodeHost ?? url;
      await Socket.connect(
          'ws://${this.url}/socketcluster/',
          authToken: authToken,
          listener: this
      );
      loadStore();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  void onAuthentication(Socket socket, bool? status) async {
    debugPrint('${DateTime.now()}: onAuthentication: status $status');
    if (status != null && !status) {
      emit('logout', 'socket');
    } else {
      if (socket.authToken != null) {
        loginInit(socket.authToken);
      } else {
        emit('logout', 'socket');
      }
    }
  }

  @override
  void onConnectError(Socket socket, e) {
    debugPrint('${DateTime.now()}: onConnectError: socket $socket e $e');
  }

  @override
  void onConnected(Socket socket) {
    debugPrint('${DateTime.now()}: onConnected');
    this.socket = socket;
    if (_timer != null) _timer!.cancel();
  }

  @override
  void onDisconnected(Socket socket) {
    debugPrint('${DateTime.now()}: onDisconnected: socket $socket');
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) => connect(url));
  }

  @override
  void onSetAuthToken(String? token, Socket socket) async {
    debugPrint('${DateTime.now()}: onSetAuthToken: socket $socket token $token');

    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('authToken', token);
      prefs.setString('lastNodeHost', url);

      loginInit(token);
    }
  }

  void loginInit(String? token) {
    closeAllChannels();
    if (token != null) {
      socket.authToken = token;
      user = User.fromMap(Jwt.parseJwt(token));
      emit('login', 'socket', user);
      initVersion();
      for (final channel in userChannels()) {
        initChannel(channel);
      }
    }
  }

  List<String> userChannels() {
    if (user == null) return [];
    return [
      'user.${user!.id}',
      'house.${user!.id}',
      'imChannels.${user!.id}',
      'votes.${user!.id}'
    ];
  }

  void initVersion() async {
    // передаем данные по используемому мобильному приложению
    final info = await PackageInfo.fromPlatform();
    Map<String, String> appInfo = {
      'version': info.version,
      'platform': Platform.operatingSystem,
      'platformVersion': Platform.operatingSystemVersion
    };
    socket.emit('service.appInfo', appInfo);
  }

  void initChannel(String name, [bool withCache = true]) {
    // предварительно проверим, что ранее не были подписаны на канал
    if (channels.where((channel) => channel == name).isNotEmpty) return;
    channels.add(name);
    socket.subscribe(name);
    socket.onSubscribe(name, (channel, data) {
      if (channel != null) {
        final event = channel.split('.');
        emit(channel, 'socket', data);
        emit(event[0], 'socket', data);
      }
    });

    if (withCache) {
      final cacheData = _box!.get(name);
      if (cacheData != null) {
        debugPrint('${DateTime.now()}: найден кэш для канала $name');
        if (name.contains('user')) {
          store.user.setUser(cacheData);
          emit('loading', 'socket', { 'channel': 'user'});
        } else if (name.contains('flats')) {
          store.flats.setFlats(
              (cacheData as List).map((flat) => flat as Flat).toList());
          emit('loading', 'socket', { 'channel': 'flats'});
          checkReady('flats');
        } else if (name.contains('posts')) {
          store.posts.setPosts(
              (cacheData as List).map((post) => post as Post).toList());
          emit('loading', 'socket', { 'channel': 'posts'});
          checkReady('posts');
        }
      }
      socket.emit('service.update', { 'channel': name, 'lastUpdated': 0});
    }
  }

  void closeChannel(String name) {
    channels.remove(name);
    socket.unsubscribe(name);
  }

  void closeAllChannels() {
    final channelsCopy = List.from(channels);
    for (var channel in channelsCopy) {
      closeChannel(channel);
    }
  }

  void loadStore() {
    on('login', this, onLogin);
    on('logout', this, onLogout);
    on('user', this, onUser);
    on('house', this, onNothing);
    on('flats', this, onFlats);
    on('posts', this, onPosts);
    on('pinnedPosts', this, onNothing);
    on('invites', this, onInvites);
    on('instructions', this, onInstructions);
    on('documents', this, onDocuments);
    on('faq', this, onFAQ);
    on('recommendations', this, onRecommendations);
    on('mutualHelp', this, onMutualHelp);
    on('votes', this, onVotes);
    on('vote', this, onVote);
    on('imChannels', this, onIMChannels);
    on('imChannel', this, onIMChannel);
    on('channel.ready', this, onNothing);
  }

  void onNothing(event, context) {
    // debugPrint('${event.eventName}: обработчик в разработке');
    // debugPrint('>>> ${event.eventData}');
  }

  void onLogin(event, context) async {
    // только если ранее еще не загружали данные
    if (store.user.value == null) store.user.setUser(user);
  }

  void onLogout(event, context) {
    // закрываем каналы
    if (store.user.value != null) {
      final userId = store.user.value!.id;
      final houseId = store.user.value!.houseId;
      final channels = [
        'posts.$houseId',
        'pinnedPosts.$houseId',
        'flats.$houseId',
        'instructions.$houseId',
        'invites.$userId',
        'documents.$houseId',
        'faq.$houseId',
        'recommendations.$houseId',
        'mutualHelp.$houseId',
      ];
      for (String channel in channels) {
        closeChannel(channel);
      }
      storeClearAll();
      _box!.clear();
    }
  }

  void onUser(event, context) async {
    if (event.eventData['event'] == 'ready') {
      debugPrint('${DateTime.now()}: подгружены с сервера данные по пользователю');
      _box!.put('user.${store.user.value!.id}', store.user.value);
      emit('loading', 'socket', { 'channel': 'user' });
      return;
    }
    final data = event.eventData['data'];
    store.user.setUser(User.fromMap(data));

    final houseId = store.user.value!.houseId;
    final channels = [
      'flats.$houseId',
      'posts.$houseId',
      'pinnedPosts.$houseId',
      'invites.${store.user.value!.id}',
      'instructions.$houseId',
      'documents.$houseId',
      'faq.$houseId',
      'recommendations.$houseId',
      'mutualHelp.$houseId',
    ];
    for (String channel in channels) {
      initChannel(channel);
    }

    socket.emit('miniapp.list', {}, (String name, dynamic error, dynamic data) {
      for (var miniApp in data) {
        store.miniApps.addMiniApp(MiniApp.fromMap(miniApp));
      }
    });
  }

  void onFlats(event, context) {
    if (event.eventData['event'] == 'ready') {
      debugPrint('${DateTime.now()}: подгружены с сервера данные по квартирым');
      _box!.put('flats.${store.user.value!.houseId}', store.flats.list);
      emit('loading', 'socket', { 'channel': 'flats' });
      checkReady('flats');
      return;
    }
    final data = event.eventData['data'];
    store.flats.addFlat(Flat.fromMap(data));
  }

  void onPosts(event, context) {
    if (event.eventData['event'] == 'ready') {
      debugPrint('${DateTime.now()}: подгружены с сервера данные по ленте новостей');
      _box!.put('posts.${store.user.value!.houseId}', store.posts.list);
      emit('loading', 'socket', { 'channel': 'posts' });
      checkReady('posts');
      return;
    }
    final data = event.eventData['data'];
    store.posts.addPost(Post.fromMap(data));
  }

  void onInvites(event, context) {
    if (event.eventData['event'] == 'ready') {
      emit('loading', 'socket', { 'channel': 'invites' });
      checkReady('invites');
      return;
    }
    final data = event.eventData['data'];
    store.invites.addInvite(Invite.fromMap(data));
  }

  void onInstructions(event, context) {
    if (event.eventData['event'] == 'ready') {
      return;
    }
    final data = event.eventData['data'];
    store.instructions.addInstruction(Instruction.fromMap(data));
  }

  void onDocuments(event, context) {
    if (event.eventData['event'] == 'ready') {
      return;
    }
    final data = event.eventData['data'];
    store.documents.addDocument(Document.fromMap(data));
  }

  void onFAQ(event, context) {
    if (event.eventData['event'] == 'ready') {
      return;
    }
    final data = event.eventData['data'];
    store.faq.addFAQItem(FAQItem.fromMap(data));
  }

  void onRecommendations(event, context) {
    if (event.eventData['event'] == 'ready') {
      return;
    }
    final data = event.eventData['data'];
    if (event.eventData['event'] != 'destroy') {
      store.recommendations.addRecommendation(Recommendation.fromMap(data));
    } else {
      store.recommendations.delRecommendation(Recommendation.fromMap(data));
    }
  }

  void onMutualHelp(event, context) {
    if (event.eventData['event'] == 'ready') {
      return;
    }
    final data = event.eventData['data'];
    if (event.eventData['event'] != 'destroy') {
      store.mutualHelp.addMutualHelpItem(MutualHelpItem.fromMap(data));
    } else {
      store.mutualHelp.delMutualHelpItem(MutualHelpItem.fromMap(data));
    }
  }

  void onVotes(event, context) {
    if (event.eventData['event'] == 'ready') {
      // подписаться на каналы по каждому пришедшему голосованию
      if (store.votes.list == null) return;
      final List<Vote> votes = store.votes.list!;
      for (Vote vote in votes) {
        // подписываемся только на каналы незакрытых голосований
        if (!vote.closed) initChannel('vote.${vote.id}', false);
      }
      return;
    }
    final data = event.eventData['data'];
    store.votes.addVote(Vote.fromMap(data));
  }

  void onVote(event, context) {
    if (event.eventData['event'] == 'ready') {
      return;
    }
    final data = event.eventData['data'];
    store.votes.addVote(Vote.fromMap(data));
  }

  void onIMChannels(event, context) {
    if (event.eventData['event'] == 'ready') {
      // подписаться на каналы по каждому доступному чату
      if (store.im.channels == null) return;
      final List<IMChannel> imChannels = store.im.channels!;
      for (IMChannel channel in imChannels) {
        initChannel('imChannel.${channel.id}', false);
      }
      return;
    }
    final data = event.eventData['data'];
    store.im.addChannel(IMChannel.fromMap(data));
  }

  void onIMChannel(event, context) {
    if (event.eventData['event'] == 'ready') {
      return;
    }
    final data = event.eventData['data'];
    store.im.addChannel(IMChannel.fromMap(data));
  }

  void storeClearAll() {
    store.clear();
  }

  void checkReady(String channel, [bool status = true]) {
    ready[channel] = status;

    // проверяем, что все данные загружены
    bool loaded = true;
    for (bool channelStatus in ready.values) {
      loaded = loaded && channelStatus;
    }
    store.setLoaded(loaded);
    if (loaded) emit('loaded', 'socket');
  }
}