import 'package:dom24x7_flutter/models/document.dart';
import 'package:dom24x7_flutter/models/faq_item.dart';
import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/instruction.dart';
import 'package:dom24x7_flutter/models/invite.dart';
import 'package:dom24x7_flutter/models/post.dart';
import 'package:dom24x7_flutter/models/recommendation.dart';
import 'package:dom24x7_flutter/models/user.dart';
import 'package:dom24x7_flutter/models/version.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:eventify/eventify.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socketcluster_client/socketcluster_client.dart';

class SocketClient extends BasicListener with EventEmitter {
  late Socket socket;
  late String url;
  MainStore store;
  User? user;
  List<String> channels = [];

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
    'votes': true,
    'imChannels': true,
  };

  SocketClient(this.store);

  void connect(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    this.url = url;
    await Socket.connect(
        'ws://$url/socketcluster/',
        authToken: authToken,
        listener: this
    );
    loadStore();
  }

  @override
  void onAuthentication(Socket socket, bool? status) async {
    debugPrint('onAuthentication: socket $socket status $status');
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
    debugPrint('onConnectError: socket $socket e $e');
  }

  @override
  void onConnected(Socket socket) {
    debugPrint('onConnected: socket $socket');
    this.socket = socket;
  }

  @override
  void onDisconnected(Socket socket) {
    debugPrint('onDisconnected: socket $socket');
    connect(url);
  }

  @override
  void onSetAuthToken(String? token, Socket socket) async {
    debugPrint('onSetAuthToken: socket $socket token $token');

    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('authToken', token);

      loginInit(token);
    }
  }

  void loginInit(String? token) {
    if (token != null) {
      socket.authToken = token;
      user = User.fromMap(Jwt.parseJwt(token));
      emit('login', 'socket', user);

      for (final name in userChannels()) {
        initChannel(name);
      }
    }
  }

  List<String> userChannels() {
    if (user == null) return [];
    return [
      'user.${user!.id}',
      'house',
      'imChannels.${user!.id}',
      'votes.${user!.id}'
    ];
  }

  void initChannel(String name) {
    channels.add(name);
    socket.subscribe(name);
    socket.onSubscribe(name, (channel, data) {
      if (channel != null) {
        final event = channel.split('.');
        emit(channel, 'socket', data);
        emit(event[0], 'socket', data);
      }
    });
  }

  void closeChannel(String name) {
    channels.remove(name);
    socket.unsubscribe(name);
  }

  void loadStore() {
    on('login', this, onLogin);
    on('logout', this, onLogout);
    on('user', this, onUser);
    on('all', this, onAll);
    on('house', this, onNothing);
    on('flats', this, onNothing);
    on('posts', this, onNothing);
    on('pinnedPosts', this, onNothing);
    on('invites', this, onNothing);
    on('instructions', this, onInstructions);
    on('documents', this, onDocuments);
    on('faq', this, onFAQ);
    on('recommendations', this, onRecommendations);
    on('votes', this, onNothing);
    on('vote', this, onNothing);
    on('imChannels', this, onNothing);
    on('imChannel', this, onNothing);
    on('channel.ready', this, onNothing);
  }

  void onNothing(event, context) {
    // debugPrint('${event.eventName}: обработчик в разработке');
    // debugPrint('>>> ${event.eventData}');
  }

  void onLogin(event, context) async {
    store.user.setUser(user);
    socket.emit('version.current', {}, (name, error, version) {
      if (version['status'] == 'ERROR') {
        if (version.message == "BANNED" || version.message == "DELETED") {
          socket.emit('user.logout', {});
          storeClearAll();
          // TODO: переходим на страницу авторизации
        }
      }
      store.version.setVersion(Version.fromMap(version));
    });
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
        'recommendations.$houseId'
      ];
      for (String channel in channels) {
        closeChannel(channel);
      }
      storeClearAll();
    }
  }

  void onUser(event, context) {
    if (event.eventData['event'] == 'ready') return;
    store.user.setUser(User.fromMap(event.eventData['data']));
    final houseId = store.user.value!.houseId;
    initChannel('all.$houseId.flats');
    if (store.user.value!.person == null || store.user.value!.resident == null) {
      // пользователь новый и еще не сформирована персона и нет привязки к квартире
      // TODO: переходим на страницу настроек
    } else {
      // пользователь уже полностью сформирован и можно подписаться на нужные каналы
      final channels = [
        'all.$houseId.posts', 'all.$houseId.invites', // начальная инициализация
        'pinnedPosts.$houseId',
        'instructions.$houseId',
        'documents.$houseId',
        'faq.$houseId',
        'recommendations.$houseId'
      ];
      for (String channel in channels) {
        initChannel(channel);
      }
    }
  }

  void onAll(event, context) {
    if (event.eventData['event'] == 'ready') return;
    final data = event.eventData['data'];
    final user = store.user.value;
    final houseId = user!.houseId;

    if (data['posts'].length != 0) {
      List<Post> posts = [];
      for (var item in data['posts']) {
        posts.add(Post.fromMap(item));
      }
      store.posts.setPosts(posts);
      closeChannel('all.$houseId.posts');
      initChannel('posts.$houseId');
      checkReady('posts');
    }
    if (data['flats'].length != 0) {
      List<Flat> flats = [];
      for (var item in data['flats']) {
        flats.add(Flat.fromMap(item));
      }
      store.flats.setFlats(flats);
      closeChannel('all.$houseId.flats');
      initChannel('flats.$houseId');
      checkReady('flats');
    }
    if (data['invites'].length != 0) {
      List<Invite> invites = [];
      for (var item in data['invites']) {
        invites.add(Invite.fromMap(item));
      }
      store.invites.setInvites(invites);
      closeChannel('all.$houseId.invites');
      initChannel('invites.${user.id}');
      checkReady('invites');
    }
  }

  void onInstructions(event, context) {
    if (event.eventData['event'] == 'ready') return;
    final data = event.eventData['data'];
    store.instructions.addInstruction(Instruction.fromMap(data));
  }

  void onDocuments(event, context) {
    if (event.eventData['event'] == 'ready') return;
    final data = event.eventData['data'];
    store.documents.addDocument(Document.fromMap(data));
  }

  void onFAQ(event, context) {
    if (event.eventData['event'] == 'ready') return;
    final data = event.eventData['data'];
    store.faq.addFAQItem(FAQItem.fromMap(data));
  }

  void onRecommendations(event, context) {
    if (event.eventData['event'] == 'ready') return;
    final data = event.eventData['data'];
    store.recommendations.addRecommendation(Recommendation.fromMap(data));
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