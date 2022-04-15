import 'package:dom24x7_flutter/models/im_channel.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/pages/im/im_messages_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IMChannelsPage extends StatelessWidget {
  const IMChannelsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final List<IMChannel> channels = store.im.channels != null ? store.im.channels! : [];

    return Scaffold(
      appBar: Header(context, 'Чаты'),
      bottomNavigationBar: Footer(context, FooterNav.im),
      body: ListView.builder(
        itemCount: channels.length,
        itemBuilder: (BuildContext context, int index) {
          final channel = channels[channels.length - index - 1];
          List<Widget> channelInfo = [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(channelTitle(store, channel), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Text(lastMessageDate(channel), style: const TextStyle(color: Colors.black26))
                ]
            )
          ];
          if (channel.lastMessage != null) {
            const maxLen = 50;
            final lastMessage = channel.lastMessage;
            if (lastMessage!.imPerson != null) {
              final person = '${imPersonTitle(lastMessage.imPerson!)}: ';
              final text = Utilities.getHeaderTitle(lastMessage.body!.text, maxLen - person.length);
              channelInfo.add(
                Row(
                  children: [
                    Text(person),
                    Text(text, style: const TextStyle(color: Colors.black26))
                  ]
                )
              );
            } else {
              final text = Utilities.getHeaderTitle(lastMessage.body!.text, maxLen);
              channelInfo.add(
                  Text(text, style: const TextStyle(color: Colors.black26))
              );
            }
          } else {
            channelInfo.add(
                const Text('нет сообщений', style: TextStyle(color: Colors.black26))
            );
          }
          return GestureDetector(
            onTap: () => { Navigator.push(context, MaterialPageRoute(builder: (context) => IMMessagesPage(channel, channelTitle(store, channel)))) },
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

  String channelTitle(MainStore store, IMChannel channel) {
    if (channel.title != null) return channel.title!;
    // раз нет заголовка, то это приватный чат с соседом, нужно указать его имя, либо квартиру
    final List<IMPerson> imPersons = channel.persons;
    late IMPerson imPerson;
    for (var item in imPersons) {
      if (item.person.id != store.user.value!.person!.id) imPerson = item;
    }
    return imPersonTitle(imPerson);
  }

  String imPersonTitle(IMPerson imPerson) {
    Person person = imPerson.person;
    String fullName = '';
    if (person.surname != null) {
      fullName += person.surname!;
    }
    if (person.name != null) {
      fullName += ' ${person.name!}';
    }
    if (person.midname != null) {
      fullName += ' ${person.midname!}';
    }
    if (fullName.trim().isEmpty) {
      final flat = imPerson.flat;
      return 'сосед(ка) из кв. №${flat.number}, этаж ${flat.floor}, подъезд ${flat.section}';
    }
    return fullName.trim();
  }

  String lastMessageDate(IMChannel channel) {
    if (channel.lastMessage == null) return '';
    return Utilities.getDateIM(channel.lastMessage!.createdAt);
  }
}