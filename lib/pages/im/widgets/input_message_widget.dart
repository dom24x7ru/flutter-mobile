import 'package:dom24x7_flutter/models/im_channel.dart';
import 'package:dom24x7_flutter/models/im_message.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef CloseEvent = void Function();
enum MessageAction { edit, answer }

class IMInputMessage extends StatefulWidget {
  final IMChannel channel;
  final IMMessage? message;
  final MessageAction? action;
  final CloseEvent close;
  const IMInputMessage(this.channel, this.message, this.action, this.close, {Key? key}) : super(key: key);

  @override
  State<IMInputMessage> createState() => _IMInputMessageState();
}

class _IMInputMessageState extends State<IMInputMessage> {
  late TextEditingController _cMessage;

  @override
  void initState() {
    super.initState();
    _cMessage = TextEditingController();
  }

  @override
  void dispose() {
    _cMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputWidget = Row(
        children: [
          Expanded(
              child: TextField(
                  controller: _cMessage,
                  decoration: const InputDecoration(
                      hintText: 'Сообщение...'
                  )
              )
          ),
          InkWell(
            onTap: () => _send(context),
            child: const Icon(Icons.send),
          )
        ]
    );
    final editAnswerWidget = Container(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(widget.action == MessageAction.answer ? Icons.keyboard_return_outlined : Icons.edit_outlined, color: Colors.black26),
            ),
            Expanded(child: Text(widget.message != null ? widget.message!.body!.text : '')),
            InkWell(
              onTap: () {
                widget.close();
                _cMessage.text = '';
              },
              child: const Icon(Icons.close)
            )
          ]
      )
    );
    List<Widget> children = [inputWidget];
    if (widget.message != null) {
      children.insert(0, editAnswerWidget);
      if (widget.action == MessageAction.edit) {
        _cMessage.text = widget.message!.body!.text;
      }
    }
    return Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children
        )
    );
  }

  _send(BuildContext context) {
    final store = Provider.of<MainStore>(context, listen: false);
    final client = store.client;
    Map<String, dynamic> data = { 'channelId': widget.channel.id, 'body': { 'text': _cMessage.text } };
    if (widget.message != null) {
      if (widget.action == MessageAction.edit) {
        // редактируем сообщение
        data['messageId'] = widget.message!.id;
        data['body'] = widget.message!.body!.toMap(); // копируем объект
        data['body']['text'] = _cMessage.text;
        if (data['body']['history'] == null) data['body']['history'] = [];
        (data['body']['history'] as List).insert(0, { 'createdAt': widget.message!.updatedAt, 'text': widget.message!.body!.text });
      }
      if (widget.action == MessageAction.answer) {
        // отвечаем на другое сообщение
        Map<String, dynamic> aMessage = { 'id': widget.message!.id, 'createdAt': widget.message!.createdAt, 'text': widget.message!.body!.text };
        data['body'] = { 'text': _cMessage.text, 'aMessage': aMessage };
      }
    }
    if (_cMessage.text.isEmpty) return;
    client.socket.emit('im.save', data, (String name, dynamic error, dynamic data) {
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
      _cMessage.text = '';
      if (widget.message != null) {
        widget.close();
      }
    });
  }
}
