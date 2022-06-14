import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/pages/house/flat_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:dom24x7_flutter/utilities.dart';
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

  @override
  void initState() {
    super.initState();

    _cFlat = TextEditingController();
    _cFlat.addListener(_findFlat);
  }

  @override
  void dispose() {
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

  void _showModalBottomSheet({ required BuildContext context, required double height, required Widget child }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: height,
              padding: const EdgeInsets.all(15.0),
              child: child
            );
          }
        );
      }
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
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () => _showModalBottomSheet(
                context: context,
                height: 180,
                child: ListView(
                  children: [
                    TextField(
                      controller: _cFlat,
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
              onPressed: () => _showModalBottomSheet(
                context: context,
                height: 100,
                child: const Text('Написать в общий чат')
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green)
              ),
              child: Text('Написать в общий чат'.toUpperCase())
            ),
            ElevatedButton(
              onPressed: () => _showModalBottomSheet(
                context: context,
                height: 320,
                child: Column(
                  children: [
                    Html(data: '''
                      <ul>
                        <li><a href="tel:102">102</a> — при звонке с мобильного</li>
                        <li><a href="tel:112">112</a> — номер экстренных оперативных служб</li>
                      </ul>
                      <p>Необходимо назвать свои ФИО, адрес места жительства и попросить данные участкового,
                      который обслуживает ваш район. Вам должны сообщить фамилию, имя, отчество, номер телефона
                      и часы приема.</p>
                      <p>Также можно найти контакты самостоятельно на сайте МВД</p>
                    '''),
                    ElevatedButton(onPressed: () => launchUrl(Uri.parse('https://xn--b1aew.xn--p1ai/district')), child: Text('Сайт МВД'.toUpperCase()))
                  ]
                )
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
              ),
              child: Text('Позвонить участковому'.toUpperCase())
            ),
            ElevatedButton(
              onPressed: () => _showModalBottomSheet(
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
        )
      )
    );
  }
}
