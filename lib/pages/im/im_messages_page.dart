import 'package:dom24x7_flutter/models/im_channel.dart';
import 'package:dom24x7_flutter/models/im_message.dart';
import 'package:dom24x7_flutter/pages/im/widgets/input_message_widget.dart';
import 'package:dom24x7_flutter/pages/im/widgets/message_widget.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _loadMessages(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollTo(_currentIndex));
    return Scaffold(
      appBar: Header(context, Utilities.getHeaderTitle(widget.title)),
      bottomNavigationBar: IMInputMessage(widget.channel),
      body: ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          final message = messages[index];
          final prev = index > 0 ? messages[index - 1] : null;
          final next = index < messages.length - 1 ? messages[index + 1] : null;
          return VisibilityDetector(
            key: Key(message.id.toString()),
            onVisibilityChanged: (VisibilityInfo info) {
              if (prev != null) return;
              if (info.visibleFraction > 0.5) {
                _currentIndex = 0;
                _loadMessages(context, offset: messages.length, more: true);
              }
            },
            child: IMMessageBlock(message, prev: prev, next: next)
          );
        }
      )
    );
  }

  _loadMessages(BuildContext context, { int limit = 20, int offset = 0, bool more = false}) {
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
  }

  _scrollTo(int index) async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.jumpTo(index: index);
    }
  }

  _addMessage(IMMessage message, bool more) {
    setState(() {
      Utilities.addOrReplaceById(messages, message);
      Utilities.sortById(messages);
      _needsScroll = true;
      if (!more) {
        _currentIndex = messages.length - 1;
      } else {
        _currentIndex++;
      }
    });
  }
}
