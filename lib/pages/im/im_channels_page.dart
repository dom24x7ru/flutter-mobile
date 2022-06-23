import 'package:badges/badges.dart';
import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/models/im/im_channel.dart';
import 'package:dom24x7_flutter/pages/im/im_messages_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IMChannelsPage extends StatefulWidget {
  const IMChannelsPage({Key? key}) : super(key: key);

  @override
  State<IMChannelsPage> createState() => _IMChannelsPageState();
}

class _IMChannelsPageState extends State<IMChannelsPage> {
  late List<IMChannel> _channels = [];
  late SocketClient _client;
  final List<dynamic> _listeners = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      setState(() => _channels = _sortIMChannels(store.im.channels != null ? store.im.channels! : []));

      _client = store.client;
      var listener = _client.on('imChannels', this, (event, cont) {
        setState(() => _channels = _sortIMChannels(store.im.channels != null ? store.im.channels! : []));
      });
      _listeners.add(listener);
      listener = _client.on('imChannel', this, (event, cont) {
        setState(() => _channels = _sortIMChannels(store.im.channels != null ? store.im.channels! : []));
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

    return Scaffold(
        appBar: Header.get(context, 'Чаты'),
        bottomNavigationBar: const Footer(FooterNav.im),
        body: ListView.builder(
            itemCount: _channels.length,
            itemBuilder: (BuildContext context, int index) {
              final channel = _channels[_channels.length - index - 1];
              List<Widget> channelInfo = [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(Utilities.getChannelTitle(store.user.value!.person!, channel), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text(_lastMessageDate(channel), style: const TextStyle(color: Colors.black26))
                    ]
                )
              ];
              if (channel.lastMessage != null) {
                const maxLen = 45;
                final lastMessage = channel.lastMessage;
                String text = lastMessage!.body!.text != null ? lastMessage.body!.text! : '';
                if (lastMessage.imPerson != null) {
                  final person = '${Utilities.getPersonTitle(lastMessage.imPerson!, store.user.value!.person!, true)}: ';
                  text = Utilities.getHeaderTitle(text, maxLen - person.length);
                  channelInfo.add(
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                children: [
                                  Text(person),
                                  Text(text, style: const TextStyle(color: Colors.black26))
                                ]
                            ),
                            channel.count > 0 ? Badge(
                              badgeContent: Text('${channel.count}', style: const TextStyle(color: Colors.white)),
                              badgeColor: Colors.blue,
                            ) : const Text('')
                          ]
                      )
                  );
                } else {
                  text = Utilities.getHeaderTitle(text, maxLen);
                  channelInfo.add(
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(text, style: const TextStyle(color: Colors.black26)),
                            channel.count > 0 ? Badge(
                              badgeContent: Text('${channel.count}', style: const TextStyle(color: Colors.white)),
                              badgeColor: Colors.blue,
                            ) : const Text('')
                          ]
                      )
                  );
                }
              } else {
                channelInfo.add(
                    const Text('нет сообщений', style: TextStyle(color: Colors.black26))
                );
              }
              return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IMMessagesPage(channel, Utilities.getChannelTitle(store.user.value!.person!, channel)))),
                  child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: channelInfo
                      )
                  )
              );
            }
        )
    );
  }

  String _lastMessageDate(IMChannel channel) {
    if (channel.lastMessage == null) return '';
    return Utilities.getDateIM(channel.lastMessage!.createdAt);
  }

  List<IMChannel> _sortIMChannels(List<IMChannel> channels) {
    List<IMChannel> sortedIMChannels = List.from(channels);
    sortedIMChannels.sort((channel1, channel2) {
      if (channel1.lastMessage == null && channel2.lastMessage == null) return 0;
      if (channel1.lastMessage != null && channel2.lastMessage != null) {
        if (channel1.lastMessage!.createdAt > channel2.lastMessage!.createdAt) return 1;
        if (channel1.lastMessage!.createdAt < channel2.lastMessage!.createdAt) return -1;
        return 0;
      }
      if (channel1.lastMessage == null) return -1;
      if (channel2.lastMessage == null) return 1;
      return 0;
    });
    return sortedIMChannels;
  }
}