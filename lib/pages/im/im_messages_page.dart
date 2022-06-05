import 'dart:io';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/im/im_channel.dart';
import 'package:dom24x7_flutter/models/im/im_message.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:dom24x7_flutter/pages/house/flat_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import "package:flutter_chat_types/flutter_chat_types.dart" as types;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

enum IMMessageMenu { profile, answer, copy, edit, delete }

class IMMessagesPage extends StatefulWidget {
  final IMChannel channel;
  final String title;
  const IMMessagesPage(this.channel, this.title, {Key? key}) : super(key: key);

  @override
  State<IMMessagesPage> createState() => _IMMessagesPageState();
}

class _IMMessagesPageState extends State<IMMessagesPage> {
  late types.User _user;
  List<types.Message> _messages = [];
  late SocketClient _client;
  final List<dynamic> _listeners = [];
  bool _mute = false;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;
      _loadMessages();
      _client.socket.emit('im.getMute', { 'channelId': widget.channel.id }, (String name, dynamic error, dynamic data) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
          );
          return;
        }
        setState(() => _mute = data['mute']);
      });

      _client.initChannel('imMessages.${widget.channel.id}');
      var listener = _client.on('imMessages', this, (event, cont) {
        final eventData = event.eventData! as Map<String, dynamic>;
        if (eventData['event'] == 'ready') return;
        final data = eventData['data'];

        final message = IMMessage.fromMap(data);
        if (message.channel!.id != widget.channel.id) return;
        if (eventData['event'] == 'destroy') {
          _delMessage(message);
        } else {
          _addMessage(_convert(message));
        }
      });
      _listeners.add(listener);
    });
  }

  @override
  void dispose() {
    for (var listener in _listeners) {
      _client.off(listener);
    }
    _client.closeChannel('imMessages.${widget.channel.id}');

    super.dispose();
  }

  types.Message _convert(IMMessage message, [types.Status status = types.Status.seen]) {
    String? firstName;
    if (message.imPerson == null) {
      firstName = 'Dom24x7 Bot';
    } else if (_imPersonNameIsEmpty(message)) {
      final flat = message.imPerson!.flat;
      firstName = 'сосед(ка) из ${Utilities.getFlatTitle(flat)}';
    } else {
      firstName = message.imPerson!.person.name;
    }

    return types.TextMessage(
      author: types.User(
        id: message.imPerson != null ? message.imPerson!.person.id.toString() : '0',
        firstName: firstName,
        lastName: message.imPerson != null ? message.imPerson!.person.surname : null,
        imageUrl: message.imPerson == null ? 'https://dom24x7-static.ru.yapahost.ru/img/im/bot.png' : null,
        metadata: message.imPerson != null ? message.imPerson!.toMap() : null
      ),
      id: message.guid,
      createdAt: message.createdAt,
      updatedAt: message.updatedAt,
      roomId: widget.channel.id.toString(),
      text: message.body!.text,
      status: status,
      metadata: { 'messageId': message.id }
    );
  }

  void _loadMessages({ int limit = 20, int offset = 0 }) {
    final data = { 'channelId': widget.channel.id, 'limit': limit, 'offset': offset };
    _client.socket.emit('im.load', data, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Не удалось загрузить список сообщений'), backgroundColor: Colors.red)
        );
        return;
      }

      final List<types.Message> newMessagesList = List.from(_messages);
      for (var msg in data) {
        final imMessage = IMMessage.fromMap(msg);
        if (imMessage.channel!.id != widget.channel.id) continue;
        final message = _convert(imMessage);
        if (newMessagesList.where((item) => item.id == message.id).isEmpty) {
          newMessagesList.add(message);
        } else {
          for (int index = 0; index < newMessagesList.length; index++) {
            if (newMessagesList[index].id == message.id) {
              newMessagesList[index] = message;
            }
          }
        }
      }
      newMessagesList.sort((msg1, msg2) => msg2.id.compareTo(msg1.id));

      setState(() => _messages = newMessagesList);
    });
  }

  void _addMessage(types.Message message) {
    setState(() => _messages.insert(0, message));
  }

  void _delMessage(IMMessage message) {
    if (message.channel!.id != widget.channel.id) return;
    final index = _messages.indexWhere((msg) => msg.id == message.guid);
    if (index == -1) return;
    setState(() => _messages.removeAt(index));
  }

  void _send(types.PartialText message) {
    Map<String, dynamic> data = { 'channelId': widget.channel.id, 'body': { 'text': message.text } };
    _client.socket.emit('im.save', data, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data == null || data['status'] != 'OK') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Произошла неизвестная ошибка. Попробуйте позже...'), backgroundColor: Colors.red)
        );
        return;
      }
    });
  }

  void _handlerAvatarTap(MainStore store, types.User user) {
    if (user.metadata == null) return;
    final flat = Flat.fromMap(user.metadata!['flat']);
    Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(_getFlat(store, flat))));
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        roomId: widget.channel.id.toString(),
        height: image.height.toDouble(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
        status: types.Status.sending
      );
      _addMessage(message);
    }
  }

  Flat _getFlat(MainStore store, Flat flat) {
    final flats = store.flats.list!;
    for (Flat item in flats) {
      if (item.id == flat.id) return item;
    }
    return flat;
  }

  String _customDateHeaderText(DateTime dt) {
    return Utilities.getDateFormat(dt.millisecondsSinceEpoch, 'dd.MM.y');
  }

  String _getAuthorTitle(types.User author) {
    String title = '';
    if (author.firstName != null) title += author.firstName!;
    if (author.lastName != null) {
      if (title.isNotEmpty) title += ' ';
      title += author.lastName!;
    }
    return title;
  }

  Widget _getMessageTimeWidget(types.Message message) {
    return Text(
      Utilities.getDateFormat(message.createdAt!, 'HH:mm'),
      style: TextStyle(color: message.author.id == _user.id ? Colors.white54 : Colors.black38)
    );
  }

  Widget _textMessageBuilder(types.TextMessage message, { required int messageWidth, required bool showName }) {
    // виджет с именем автора
    Widget authorTitleWidget = Text(_getAuthorTitle(message.author), style: const TextStyle(fontWeight: FontWeight.bold));

    // виджет сообщения
    Widget messageWidget = Text(message.text, style: TextStyle(color: message.author.id == _user.id ? Colors.white : Colors.black));
    if (isURL(message.text)) {
      String url = message.text;
      if (!url.contains('https://')) url = 'https://$url';
      messageWidget = AnyLinkPreview(
        link: url,
        cache: const Duration(hours: 1),
        backgroundColor: message.author.id == _user.id ? Colors.indigo : Colors.white12,
        titleStyle: TextStyle(color: message.author.id == _user.id ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
        bodyStyle: TextStyle(color: message.author.id == _user.id ? Colors.white : Colors.black),
        removeElevation: true,
        errorBody: 'Ой! Не удалось получить данные по ссылке',
        errorImage: 'Ой! Не удалось загрузить картинку',
        errorTitle: 'Ой! Что-то не так с заголовком',
      );
    }

    // контайнер сообщения
    final messageColumns = [messageWidget, _getMessageTimeWidget(message)];
    if (message.author.id != _user.id && showName) {
      messageColumns.insert(0, const SizedBox(height: 5.0));
      messageColumns.insert(0, authorTitleWidget);
    }
    final messageContainer = Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: messageColumns
      )
    );

    return messageContainer;
  }

  Widget _imageMessageBuilder(types.ImageMessage message, { required int messageWidth }) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(image: FileImage(File(message.uri))),
          _getMessageTimeWidget(message)
        ]
      ),
    );
  }

  void _showMenu(BuildContext context, types.Message message) async {
    if (message.author.metadata == null) return;

    List<PopupMenuEntry<IMMessageMenu>> items = [
      PopupMenuItem<IMMessageMenu>(
          value: IMMessageMenu.profile,
          child: Row(children: const [
            Icon(Icons.person_outline),
            Text(' Профиль')
          ])
      ),
      // PopupMenuItem<IMMessageMenu>(
      //     value: IMMessageMenu.answer,
      //     child: Row(children: const [
      //       Icon(Icons.keyboard_return_outlined),
      //       Text(' Ответить')
      //     ])
      // ),
      PopupMenuItem<IMMessageMenu>(
          value: IMMessageMenu.copy,
          child: Row(
              children: const [Icon(Icons.copy), Text(' Копировать')])
      )
    ];
    if (message.author.metadata!['person']['id'].toString() == _user.id) {
      // items.add(PopupMenuItem<IMMessageMenu>(
      //     value: IMMessageMenu.edit,
      //     child: Row(children: const [
      //       Icon(Icons.edit_outlined),
      //       Text(' Изменить')
      //     ])
      // ));
      items.add(PopupMenuItem<IMMessageMenu>(
          value: IMMessageMenu.delete,
          child: Row(children: const [
            Icon(Icons.delete_outline),
            Text(' Удалить')
          ])
      ));
    }

    IMMessageMenu? item = await showMenu<IMMessageMenu>(
      context: context,
      position: RelativeRect.fromLTRB(
          _tapPosition!.dx - 10,
          _tapPosition!.dy - 10,
          _tapPosition!.dx + 10,
          _tapPosition!.dy + 10
      ),
      items: items
    );
    if (item == null) return;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      switch (item) {
        case IMMessageMenu.profile: // посмотреть данные по пользователю
          _handlerAvatarTap(store, message.author);
          break;
        case IMMessageMenu.answer: // ответить на сообщение
          break;
        case IMMessageMenu.copy: // скопировать сообщение в буфер
          Clipboard.setData(ClipboardData(text: (message as types.TextMessage).text));
          break;
        case IMMessageMenu.edit: // редактировать сообщение
          break;
        case IMMessageMenu.delete: // удалить сообщение
          _client.socket.emit('im.del', { 'messageId': message.metadata!['messageId'] }, (String name, dynamic error, dynamic data) {
            if (error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
              );
            }
          });
          break;
      }
    });
  }

  bool _imPersonNameIsEmpty(IMMessage message) {
    Person person = message.imPerson!.person;
    return person.surname == null && person.name == null;
  }

  void _getPosition(TapDownDetails details) {
    setState(() => _tapPosition = details.globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final person = store.user.value!.person;
    _user = types.User(id: person!.id.toString());

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Text(Utilities.getHeaderTitle(widget.title))]),
        actions: [
          IconButton(
            icon: Icon(_mute ? Icons.volume_off : Icons.volume_up),
            onPressed: () {
              _client.socket.emit('im.setMute', { 'channelId': widget.channel.id, 'mute': !_mute }, (String name, dynamic error, dynamic data) {
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
                  );
                  return;
                }
                setState(() => _mute = data['mute']);
              });
            }
          )
        ]
      ),
      body: GestureDetector(
        onTapDown: _getPosition,
        child: Chat(
          l10n: const ChatL10nRu(),
          theme: const DefaultChatTheme(
            attachmentButtonIcon: Icon(Icons.attach_file, color: Colors.white),
            inputBackgroundColor: Colors.blue,
            inputTextCursorColor: Colors.white,
            primaryColor: Colors.indigo
          ),
          showUserNames: !widget.channel.private!,
          showUserAvatars: true,
          sendButtonVisibilityMode: SendButtonVisibilityMode.always,
          customDateHeaderText: _customDateHeaderText,
          textMessageBuilder: _textMessageBuilder,
          imageMessageBuilder: _imageMessageBuilder,
          user: _user,
          messages: _messages,
          onEndReached: () async => _loadMessages(offset: _messages.length),
          onSendPressed: _send,
          onAvatarTap: (types.User user) => _handlerAvatarTap(store, user),
          onMessageTap: _showMenu,
          onAttachmentPressed: _handleImageSelection,
        )
      )
    );
  }
}
