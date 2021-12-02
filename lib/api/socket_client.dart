import 'dart:ffi';

import 'package:dom24x7_flutter/models/role.dart';
import 'package:dom24x7_flutter/models/user.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:socketcluster_client/socketcluster_client.dart';

class SocketClient extends BasicListener {
  late Socket socket;
  late User user;
  List<String> channels = [];

  static void connect(String url) async {
    await Socket.connect('ws://$url/socketcluster/', listener: SocketClient());
  }

  @override
  void onAuthentication(Socket socket, bool? status) {
    print('onAuthentication: socket $socket status $status');
    if (status != null && !status) {
      socket.emit('user.auth', { 'mobile': '79258779819', 'code': '8731' });
    }
  }

  @override
  void onConnectError(Socket socket, e) {
    print('onConnectError: socket $socket e $e');
  }

  @override
  void onConnected(Socket socket) {
    print('onConnected: socket $socket');
  }

  @override
  void onDisconnected(Socket socket) {
    print('onDisconnected: socket $socket');
  }

  @override
  void onSetAuthToken(String? token, Socket socket) {
    print('onSetAuthToken: socket $socket token $token');
    socket.authToken = token;
    this.socket = socket;
    if (token != null) {
      Map<String, dynamic> user = Jwt.parseJwt(token);
      this.user = User(user['id'], user['mobile'], user['banned'], Role(user['role']['id'], user['role']['name']));
      for (final name in userChannels()) {
        initChannel(name);
      }
    }
  }

  List<String> userChannels() {
    return [
      'user.${user.id}',
      'house',
      'imChannels.${user.id}',
      'votes.${user.id}'
    ];
  }

  void initChannel(String name) {
    channels.add(name);
    socket.subscribe(name);
    socket.onSubscribe(name, (event, data) => {
      print('$event data: $data')
    });
  }

  void closeChannel(String name) {
    channels.remove(name);
    socket.unsubscribe(name);
  }
}