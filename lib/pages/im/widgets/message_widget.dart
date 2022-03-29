import 'package:dom24x7_flutter/models/im_message.dart';
import 'package:dom24x7_flutter/models/person.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:flutter/material.dart';

class IMMessageBlock extends StatefulWidget {
  final IMMessage message;
  final IMMessage? prev;
  final IMMessage? next;
  const IMMessageBlock(this.message, {Key? key, this.prev, this.next}) : super(key: key);

  @override
  State<IMMessageBlock> createState() => _IMMessageBlockState();
}

class _IMMessageBlockState extends State<IMMessageBlock> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Text(widget.message.body!.text),
      Text(Utilities.getDateFormat(widget.message.createdAt), style: const TextStyle(color: Colors.black26))
    ];

    // нужно показывать имя написавшего сообщение
    final prevPersonTitle = _imPersonTitle(widget.prev);
    final personTitle = _imPersonTitle(widget.message);
    if (personTitle != null && personTitle != prevPersonTitle) {
      children.insert(0, Text(personTitle, style: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.blue)));
    }

    // нужно ли показывать дату
    final date = Utilities.getDateFormatShort(widget.message.createdAt);
    if (widget.prev == null) {
      children.insert(0, _showDateBlock(date));
    } else {
      final prevDate = Utilities.getDateFormatShort(widget.prev!.createdAt);
      if (date != prevDate) {
        children.insert(0, _showDateBlock(date));
      }
    }

    return Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
        )
    );
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
