import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/flat.dart';
import 'package:dom24x7_flutter/models/im_channel.dart';
import 'package:dom24x7_flutter/models/im_message.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/pages/house/flat_page.dart';
import 'package:dom24x7_flutter/pages/im/widgets/input_message_widget.dart';
import 'package:dom24x7_flutter/pages/im/widgets/message_widget.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

enum IMMessageMenu { profile, answer, copy, edit, delete }

class IMMessagesPage extends StatefulWidget {
  final IMChannel channel;
  final String title;
  const IMMessagesPage(this.channel, this.title, {Key? key}) : super(key: key);

  @override
  State<IMMessagesPage> createState() => _IMMessagesPageState();
}

class _IMMessagesPageState extends State<IMMessagesPage> {
  late List<IMMessage> messages = [];
  late int _currentIndex = 0;
  final ItemScrollController _scrollController = ItemScrollController();
  bool _needsScroll = false;
  late SocketClient _client;
  final List<dynamic> _listeners = [];
  IMMessage? message;
  MessageAction? action;
  bool mute = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _client = _loadMessages(context);
      _client.socket.emit('im.getMute', { 'channelId': widget.channel.id }, (String name, dynamic error, dynamic data) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
          );
          return;
        }
        setState(() => { mute = data['mute'] });
      });

      var listener = _client.on('imMessages', this, (event, cont) {
        final eventData = event.eventData! as Map<String, dynamic>;
        if (eventData['event'] == 'ready') return;
        final data = eventData['data'];
        print(data);
        if (eventData['event'] == 'destroy') {
          _delMessage(IMMessage.fromMap(data), false);
        } else {
          _addMessage(IMMessage.fromMap(data), false);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final person = store.user.value!.person;

    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollTo(_currentIndex));
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Text(Utilities.getHeaderTitle(widget.title))]),
        actions: [
          IconButton(
            icon: Icon(mute ? Icons.volume_off : Icons.volume_up),
            onPressed: () {
              _client.socket.emit('im.setMute', { 'channelId': widget.channel.id, 'mute': !mute }, (String name, dynamic error, dynamic data) {
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
                  );
                  return;
                }
                setState(() => { mute = data['mute'] });
              });
            }
          )
        ]
      ),
      body: Stack(
        children: [
          _messagesListView(person),
          Align(
            alignment: Alignment.bottomLeft,
            child: _inputMessage()
          )
        ]
      )
    );
  }

  Widget _inputMessage() {
    return IMInputMessage(widget.channel, message, action, () {
      setState(() {
        message = null;
        action = null;
      });
    });
  }

  Widget _messagesListView(Person? person) {
    final store = Provider.of<MainStore>(context);
    final person = store.user.value!.person;
    return ScrollablePositionedList.builder(
        physics: const BouncingScrollPhysics(),
        itemScrollController: _scrollController,
        padding: const EdgeInsets.only(bottom: 70.0),
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          final message = messages[index];
          final prev = index > 0 ? messages[index - 1] : null;
          final next = index < messages.length - 1 ? messages[index + 1] : null;
          final msgBlockWidget = VisibilityDetector(
              key: Key(message.id.toString()),
              onVisibilityChanged: (VisibilityInfo info) {
                if (prev != null) return;
                if (info.visibleFraction > 0.5) {
                  _currentIndex = 0;
                  _loadMessages(context, offset: messages.length, more: true);
                }
              },
              child: IMMessageBlock(
                message,
                prev: prev,
                next: next
              )
          );

          if (message.imPerson != null) {
            List<PopupMenuItem<IMMessageMenu>> contextMenu = [
              PopupMenuItem<IMMessageMenu>(
                  value: IMMessageMenu.profile,
                  child: Row(children: const [
                    Icon(Icons.person_outline),
                    Text(' Профиль')
                  ])
              ),
              PopupMenuItem<IMMessageMenu>(
                  value: IMMessageMenu.answer,
                  child: Row(children: const [
                    Icon(Icons.keyboard_return_outlined),
                    Text(' Ответить')
                  ])
              ),
              PopupMenuItem<IMMessageMenu>(
                  value: IMMessageMenu.copy,
                  child: Row(
                      children: const [Icon(Icons.copy), Text(' Копировать')])
              )
            ];
            if (message.imPerson!.person.id == person!.id) {
              contextMenu.add(PopupMenuItem<IMMessageMenu>(
                  value: IMMessageMenu.edit,
                  child: Row(children: const [
                    Icon(Icons.edit_outlined),
                    Text(' Изменить')
                  ])
              ));
              contextMenu.add(PopupMenuItem<IMMessageMenu>(
                  value: IMMessageMenu.delete,
                  child: Row(children: const [
                    Icon(Icons.delete_outline),
                    Text(' Удалить')
                  ])
              ));
            }
            return PopupMenuButton<IMMessageMenu>(
                child: msgBlockWidget,
                itemBuilder: (BuildContext context) => contextMenu,
                onSelected: (IMMessageMenu item) =>
                {
                  _onSelected(store, item, message)
                }
            );
          } else {
            return msgBlockWidget;
          }
        }
    );
  }

  SocketClient _loadMessages(BuildContext context, { int limit = 20, int offset = 0, bool more = false}) {
    final store = Provider.of<MainStore>(context, listen: false);
    final client = store.client;

    final data = { 'channelId': widget.channel.id, 'limit': limit, 'offset': offset };
    client.socket.emit('im.load', data, (String name, dynamic error, dynamic data) {
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
      for (var msg in data) {
        _addMessage(IMMessage.fromMap(msg), more);
      }
    });

    return client;
  }

  void _scrollTo(int index) async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.jumpTo(index: index);
    }
  }

  void _addMessage(IMMessage message, bool more) {
    setState(() {
      final oldMessagesLength = messages.length;
      Utilities.addOrReplaceById(messages, message);
      if (oldMessagesLength != messages.length) {
        Utilities.sortById(messages);
        _needsScroll = true;
        if (!more) {
          _currentIndex = messages.length - 1;
        } else {
          _currentIndex++;
        }
      }
    });
  }

  void _delMessage(IMMessage message, bool more) {
    setState(() {
      Utilities.deleteById(messages, message);
      Utilities.sortById(messages);
      _needsScroll = true;
      if (!more) {
        _currentIndex = messages.length - 1;
      } else {
        _currentIndex--;
      }
    });
  }

  void _onSelected(MainStore store, IMMessageMenu item, IMMessage message) {
    switch (item) {
      case IMMessageMenu.profile: // посмотреть данные по пользователю
        final flat = message.imPerson?.flat;
        if (flat != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(_getFlat(store, message))));
        }
        break;
      case IMMessageMenu.answer: // ответить на сообщение
        setState(() {
          this.message = message;
          action = MessageAction.answer;
        });
        break;
      case IMMessageMenu.copy: // скопировать сообщение в буфер
        final text = message.body!.text;
        Clipboard.setData(ClipboardData(text: text));
        break;
      case IMMessageMenu.edit: // редактировать сообщение
        setState(() {
          this.message = message;
          action = MessageAction.edit;
        });
        break;
      case IMMessageMenu.delete: // удалить сообщение
        final store = Provider.of<MainStore>(context, listen: false);
        final client = store.client;
        client.socket.emit('im.del', { 'messageId': message.id }, (String name, dynamic error, dynamic data) {
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
            );
            return;
          }
        });
        break;
    }
  }

  Flat _getFlat(MainStore store, IMMessage message) {
    Flat? flat = message.imPerson?.flat;
    final flats = store.flats.list!;
    for (Flat item in flats) {
      if (item.id == flat!.id) return item;
    }
    return flat!;
  }
}
