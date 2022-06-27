import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/im/im_message_body.dart';
import 'package:dom24x7_flutter/pages/house/flat_page.dart';
import 'package:dom24x7_flutter/pages/im/im_messages_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NoisePage extends StatefulWidget {
  const NoisePage({Key? key}) : super(key: key);

  @override
  State<NoisePage> createState() => _NoisePageState();
}

class _NoisePageState extends State<NoisePage> {
  List<Flat>? _flats;
  Flat? _flat;
  late TextEditingController _cFlat;
  late TextEditingController _cIMMessage;

  @override
  void initState() {
    super.initState();

    _cFlat = TextEditingController();
    _cFlat.addListener(_findFlat);

    _cIMMessage = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final store = Provider.of<MainStore>(context, listen: false);
      final miniapp = store.miniApps.list!.firstWhere((item) => item.extra.code == 'noise');
      _cIMMessage.text = miniapp.extra.more['text'];
    });
  }

  @override
  void dispose() {
    _cIMMessage.dispose();
    _cFlat.removeListener(_findFlat);
    _cFlat.dispose();

    super.dispose();
  }

  void _findFlat() {
    if (_flats == null) return;
    for (Flat flat in _flats!) {
      if (flat.number.toString() == _cFlat.text) {
        setState(() => _flat = flat);
        return;
      }
    }
  }

  void _showBottomSheet({ required BuildContext context, required double height, required Widget child }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: height,
          padding: const EdgeInsets.all(15.0),
          child: child
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<MainStore>(context);
    setState(() => _flats = store.flats.list);

    const noiseTitle = Text('Можно шуметь', style: TextStyle(fontSize: 24.0));
    const noiseBody = Text(
        'ПН - СБ: 09:00 - 21:00\nПерерыв (тихий час): 13:00 - 15:00',
        style: TextStyle(fontSize: 18.0)
    );
    const silenceTitle = Text('Нельзя шуметь', style: TextStyle(fontSize: 24.0));
    const silenceBody = Text(
        'ПН - СБ: 21:00 - 09:00\nВС, праздничные дни',
        style: TextStyle(fontSize: 18.0)
    );
    const description = Text('''
Шуметь - это:
- громко слушать музыку дома и в автомобиле у дома;
- использовать строительную технику;
- взрывать петарды и запускать фейерверки;
- кричать, свистеть и громко петь;
- сверлить, стучать и рубить;
- играть на музыкальных инструментах.
        ''',
        style: TextStyle(fontSize: 18.0)
    );

    return Scaffold(
      appBar: Header.get(context, 'Шумит сосед'),
      bottomNavigationBar: const Footer(FooterNav.services),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ListView(
                children: [
                  ElevatedButton(
                      onPressed: () => _showBottomSheet(
                          context: context,
                          height: 450,
                          child: ListView(
                              children: [
                                TextField(
                                    controller: _cFlat,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(hintText: 'Введите номер квартиры')
                                ),
                                const SizedBox(height: 15.0),
                                ElevatedButton(
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FlatPage(_flat))),
                                    child: Text('Перейти'.toUpperCase())
                                )
                              ]
                          )
                      ),
                      child: Text('Позвонить соседу'.toUpperCase())
                  ),
                  ElevatedButton(
                      onPressed: () => _showBottomSheet(
                          context: context,
                          height: 600,
                          child: ListView(
                              children: [
                                TextField(
                                  controller: _cIMMessage,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                      labelText: 'Текст сообщения'
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                                ElevatedButton(
                                    onPressed: () {
                                      final text = _cIMMessage.text;
                                      if (text.trim().isEmpty) return;

                                      final channel = store.im.channels!.firstWhere((item) => item.allHouse != null && item.allHouse!);
                                      final guid = '${channel.id}-${DateTime.now().millisecondsSinceEpoch}';
                                      final body = IMMessageBody.fromMap({ 'text': text });
                                      Map<String, dynamic> data = { 'guid': guid, 'channelId': channel.id, 'body': body.toMap() };
                                      store.client.socket.emit('im.save', data, (String name, dynamic error, dynamic data) {
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

                                        Navigator.push(context, MaterialPageRoute(builder: (context) => IMMessagesPage(channel, channel.title!)));
                                      });
                                    },
                                    child: Text('Отправить'.toUpperCase())
                                )
                              ]
                          )
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green)
                      ),
                      child: Text('Написать в общий чат'.toUpperCase())
                  ),
                  ElevatedButton(
                      onPressed: () => _showBottomSheet(
                          context: context,
                          height: 240,
                          child: Column(
                              children: [
                                Html(data: '<p>Для вызова участкового необходимо с мобльного номера позвонить на номер 102 и сообщить номер квартиры где по вашему предположению шумят</p>'),
                                ElevatedButton(onPressed: () => launchUrl(Uri.parse('tel:102')), child: Text('Позвонить'.toUpperCase())),
                                Html(data: '<p>Также вы можете зайти на сайт <a href="https://xn--b1aew.xn--p1ai/district">МВД</a> и найти контактные данные участкового по своему району</p>')
                              ]
                          )
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                      ),
                      child: Text('Позвонить участковому'.toUpperCase())
                  ),
                  ElevatedButton(
                      onPressed: () => _showBottomSheet(
                          context: context,
                          height: 380,
                          child: Html(data: '''
                  <p>Итак, в вашей квартире есть батареи. Если не было перепланировок, ты вы можете обнаружить
                  эти устройства под окнами в каждом помещении квартиры.</p> 
                  <p>Эти штуковины прекрасно проводят звук по многим квартирам и этим можно воспользоваться.</p>
                  <p>Возьмите какой-нибудь твердый предмет и слегка ударьте им по батарее. Вы услышите
                  характерный громкий звук. Для привлечения внимания, можете отстучать собачий вальс).</p>
                  <p>Советуем не использовать тяжелые предметы, которые могут повредить батарею.</p>
                  <p>Данные рекомендации имеют шуточный характер, не призывают к действию и не гарантируют
                  желаемый результат).</p>
                ''')
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red)
                      ),
                      child: Text('Постучать по батарее'.toUpperCase())
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 45.0),
                        noiseTitle, SizedBox(height: 10.0), noiseBody,
                        SizedBox(height: 30.0),
                        silenceTitle, SizedBox(height: 10.0), silenceBody,
                        SizedBox(height: 30.0),
                        description
                      ]
                  )
                ]
            );
          },
        )
      )
    );
  }
}
