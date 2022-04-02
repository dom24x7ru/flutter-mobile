import 'package:dom24x7_flutter/models/im_channel.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IMInputMessage extends StatefulWidget {
  final IMChannel channel;
  const IMInputMessage(this.channel, {Key? key}) : super(key: key);

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
    return Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
        color: Colors.white,
        child: Row(
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
                onTap: () => { _send(context) },
                child: const Icon(Icons.send),
              )
            ]
        )
    );
  }

  _send(BuildContext context) {
    final store = Provider.of<MainStore>(context, listen: false);
    final client = store.client;
    final data = { 'channelId': widget.channel.id, 'body': { 'text': _cMessage.text } };
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
    });
  }
}
