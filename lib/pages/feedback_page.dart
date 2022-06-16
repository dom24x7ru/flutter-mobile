import 'package:dom24x7_flutter/api/socket_client.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  late TextEditingController _cTitle;
  late TextEditingController _cBody;
  late SocketClient _client;

  @override
  void initState() {
    super.initState();
    _cTitle = TextEditingController();
    _cBody = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      _client = store.client;
    });
  }

  @override
  void dispose() {
    _cTitle.dispose();
    _cBody.dispose();
    super.dispose();
  }

  void _send() {
    final data = {
      'title': _cTitle.text.trim(),
      'body': _cBody.text.trim()
    };
    if (data['title']!.isEmpty || data['body']!.isEmpty) return;
    _client.socket.emit('feedback.send', data, (String name, dynamic error, dynamic data) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${error['code']}: ${error['message']}'), backgroundColor: Colors.red)
        );
        return;
      }
      if (data != null) {
        if (data['status'] == 'OK') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Сообщение успешно отправлено'), backgroundColor: Colors.green)
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Что-то пошло не так, попробуйте позже'), backgroundColor: Colors.red)
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Сервер не вернул ответ, попробуйте позже'), backgroundColor: Colors.red)
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.get(context, 'Обратная связь'),
      bottomNavigationBar: const Footer(null),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            TextField(
              controller: _cTitle,
              decoration: const InputDecoration(
                label: Text('Заголовок')
              )
            ),
            TextField(
              controller: _cBody,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                label: Text('Подробное описание')
              )
            ),
            ElevatedButton(
              onPressed: _send,
              child: Text('Отправить'.toUpperCase())
            )
          ]
        ),
      )
    );
  }
}
