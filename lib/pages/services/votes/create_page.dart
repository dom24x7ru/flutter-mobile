import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/widgets/checkbox_widget.dart';
import 'package:dom24x7_flutter/widgets/radio_widget.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../store/main.dart';

enum VoteType { house, section, floor }

class Answer {
  int id;
  late TextEditingController controller;
  Answer(this.id) {
    controller = TextEditingController();
  }
}

class VoteCreatePage extends StatefulWidget {
  const VoteCreatePage({Key? key}) : super(key: key);

  @override
  State<VoteCreatePage> createState() => _VoteCreatePageState();
}

class _VoteCreatePageState extends State<VoteCreatePage> {
  bool _anonymous = false;
  bool _multi = false;
  VoteType? _voteType;
  final List<Answer> _answers = [];

  late TextEditingController _cQuestion;

  bool _btnEnabled = false;

  @override
  void initState() {
    super.initState();

    _cQuestion = TextEditingController();
  }

  @override
  void dispose() {
    _cQuestion.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    final Flat flat = store.user.value!.residents[0].flat!;

    if (flat.section == null) {
      setState(() => _voteType = VoteType.house);
    }

    List<Widget> voteCoverage = [];
    if (flat.section != null) {
      voteCoverage.add(
        Dom24x7Radio<VoteType>(
          value: VoteType.house,
          groupValue: _voteType,
          label: 'весь дом',
          onChanged: (VoteType? value) {
            setState(() {
              _voteType = value;
              _calcBtnEnabled();
            });
          },
        )
      );
      voteCoverage.add(
        Dom24x7Radio<VoteType>(
          value: VoteType.section,
          groupValue: _voteType,
          label: 'весь подъезд',
          onChanged: (VoteType? value) {
            setState(() {
              _voteType = value;
              _calcBtnEnabled();
            });
          },
        )
      );
    }
    if (flat.section != null && flat.floor != null) {
      voteCoverage.add(
        Dom24x7Radio<VoteType>(
          value: VoteType.floor,
          groupValue: _voteType,
          label: 'весь этаж в подъезде',
          onChanged: (VoteType? value) {
            setState(() {
              _voteType = value;
              _calcBtnEnabled();
            });
          },
        )
      );
    }
    return Scaffold(
      appBar: Header(context, 'Создать голосование'),
      bottomNavigationBar: const Footer(FooterNav.services),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            TextField(
              controller: _cQuestion,
              onChanged: (String value) => _calcBtnEnabled(),
              decoration: const InputDecoration(
                labelText: 'Задайте вопрос'
              )
            ),
            Column(children: _getAnswerWidgets()),
            TextButton(onPressed: () => _addAnswer(), child: Text('Добавить ответ'.toUpperCase())),
            Dom24x7Checkbox(value: _anonymous, label: 'анонимно', onChanged: (bool? value) => setState(() => _anonymous = value!)),
            Dom24x7Checkbox(value: _multi, label: 'несколько ответов', onChanged: (bool? value) => setState(() => _multi = value!)),
            ...voteCoverage,
            ElevatedButton(
              onPressed: _btnEnabled ? () => _save(context, store) : null,
              child: Text('Сохранить'.toUpperCase()),
            )
          ]
        )
      )
    );
  }

  List<Widget> _getAnswerWidgets() {
    return _answers.map((answer) {
      return TextField(
          controller: answer.controller,
          onChanged: (String value) => _calcBtnEnabled(),
          decoration: InputDecoration(
              labelText: 'Ответ',
              hintText: 'Укажите вариант ответа',
              suffixIcon: InkWell(
                onTap: () => _delAnswer(answer.id),
                child: const Icon(Icons.delete_outline)
              )
          )
      );
    }).toList();
  }

  void _addAnswer() {
    setState(() {
      _answers.add(Answer(DateTime.now().millisecondsSinceEpoch));
    });
  }

  void _delAnswer(int id) {
    Answer? removeObj;
    for (Answer answer in _answers) {
      if (answer.id == id) removeObj = answer;
    }
    if (removeObj != null) {
      setState(() {
        _answers.remove(removeObj);
      });
    }
  }

  void _calcBtnEnabled() {
    setState(() {
      _btnEnabled = _cQuestion.text.trim().isNotEmpty // вопрос не должен быть пусты
          && _checkAnswers() // количество вариантнов ответов больше одного и они должны быть заполнены
          && _voteType != null; // выбран тип голосования
    });
  }

  bool _checkAnswers() {
    // не менее двух ответов
    if (_answers.length < 2) return false;
    // все ответы должны быть заполнены
    for (Answer answer in _answers) {
      if (answer.controller.text.isEmpty) return false;
    }
    return true;
  }

  void _save(BuildContext context, MainStore store) {
    var data = {
      'title': _cQuestion.text.trim(),
      'questions': _answers.map((answer) { return { 'body': answer.controller.text.trim() }; }).toList(),
      'anonymous': _anonymous,
      'multi': _multi,
      'type': _voteType.toString().split('.').last
    };
    store.client.socket.emit('vote.save', data, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data != null && data['status'] == 'OK') {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Не удалось сохранить голосование. Попробуйте позже'), backgroundColor: Colors.red)
        );
      }
    });
  }
}
