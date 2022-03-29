import 'package:dom24x7_flutter/models/im_channel.dart';
import 'package:dom24x7_flutter/models/im_message.dart';
import 'package:dom24x7_flutter/pages/im/widgets/input_message_widget.dart';
import 'package:dom24x7_flutter/pages/im/widgets/message_widget.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IMMessagesPage extends StatefulWidget {
  final IMChannel channel;
  final String title;
  const IMMessagesPage(this.channel, this.title, {Key? key}) : super(key: key);

  @override
  State<IMMessagesPage> createState() => _IMMessagesPageState();
}

class _IMMessagesPageState extends State<IMMessagesPage> {
  late List<IMMessage> messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _needsScroll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      final client = store.client;
      final data = { 'channelId': widget.channel.id, 'limit': 20, 'offset': 0 };
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
          _addMessage(IMMessage.fromMap(msg));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToEnd());
    return Scaffold(
      appBar: Header(context, Utilities.getHeaderTitle(widget.title)),
      bottomNavigationBar: IMInputMessage(widget.channel),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          final message = messages[index];
          return IMMessageBlock(message);
        }
      )
    );
  }

  Widget showDateBlock(String dt) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      width: double.infinity,
      child: Text(dt, textAlign: TextAlign.center),
    );
  }

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut
      );
    }
  }

  _addMessage(IMMessage message) {
    setState(() {
      Utilities.addOrReplaceById(messages, message);
      _needsScroll = true;
    });
  }
}
