import 'package:dom24x7_flutter/models/im_channel.dart';
import 'package:flutter/material.dart';

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
                onTap: () => {},
                child: const Icon(Icons.send),
              )
            ]
        )
    );
  }
}
