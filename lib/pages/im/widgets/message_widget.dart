import 'package:dom24x7_flutter/models/im_message.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef ShownEvent = void Function(IMMessage message);

class IMMessageBlock extends StatefulWidget {
  final IMMessage message;
  final IMMessage? prev;
  final IMMessage? next;
  final bool isAnswer;
  final ShownEvent? shownEvent;
  const IMMessageBlock(this.message, {Key? key, this.prev, this.next, this.isAnswer = false, this.shownEvent}) : super(key: key);

  @override
  State<IMMessageBlock> createState() => _IMMessageBlockState();
}

class _IMMessageBlockState extends State<IMMessageBlock> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final person = store.user.value!.person;
    if (widget.message.extra!.shown.firstWhere((personId) => personId == person!.id, orElse: () => -1) == -1) {
      // отправляем запрос только если сообщение еще не было просмотрено
      store.client.socket.emit('im.shown', { 'messageId': widget.message.id });
      if (widget.shownEvent != null) widget.shownEvent!(widget.message);
    }

    List<Widget> children = [Text(widget.message.body!.text)];

    // добавляем дату создания сообщения
    if (!widget.isAnswer) {
      final timeWidget = Text(
          Utilities.getTimeFormat(widget.message.createdAt),
          style: const TextStyle(color: Colors.black26)
      );
      if (widget.message.body!.history.isEmpty) {
        children.add(timeWidget);
      } else {
        children.add(Row(
          children: [
            const Text('исправлено ', style: TextStyle(color: Colors.black26)),
            timeWidget
          ]
        ));
      }
    }

    // является ли сообщение ответом на другое
    final aMessage = widget.message.body!.aMessage;
    if (aMessage != null) {
      children.insert(0, IMMessageBlock(aMessage, isAnswer: true));
    }

    // нужно показывать имя написавшего сообщение
    final prevPersonTitle = _imPersonTitle(widget.prev);
    final personTitle = _imPersonTitle(widget.message);
    if (personTitle != null && personTitle != prevPersonTitle) {
      children.insert(0, Text(personTitle, style: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.blue)));
    }

    // нужно ли показывать блок с датой
    if (!widget.isAnswer) {
      final date = Utilities.getDateFormatShort(widget.message.createdAt);
      if (widget.prev == null) {
        children.insert(0, _showDateBlock(date));
      } else {
        final prevDate = Utilities.getDateFormatShort(widget.prev!.createdAt);
        if (date != prevDate) {
          children.insert(0, _showDateBlock(date));
        }
      }
    }

    Widget msgBlockWidget = Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
        )
    );

    if (widget.isAnswer) {
      msgBlockWidget = Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.blue, width: 3)
              )
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children
          )
      );
    }

    return msgBlockWidget;
  }

  String? _imPersonTitle(IMMessage? message) {
    if (message == null) return null;
    if (message.imPerson == null) return null;
    Person person = message.imPerson!.person;
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
      final flat = message.imPerson!.flat;
      return 'сосед(ка) из кв. №${flat.number}, этаж ${flat.floor}, подъезд ${flat.section}';
    }
    return fullName.trim();
  }

  Widget _showDateBlock(String dt) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      width: double.infinity,
      child: Text(dt, textAlign: TextAlign.center),
    );
  }
}
