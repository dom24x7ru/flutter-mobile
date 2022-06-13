import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class NoisePage extends StatefulWidget {
  const NoisePage({Key? key}) : super(key: key);

  @override
  State<NoisePage> createState() => _NoisePageState();
}

class _NoisePageState extends State<NoisePage> {
  void _showModalBottomSheet({ required BuildContext context, required double height, required Widget child }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      builder: (BuildContext context) {
        return Container(
          height: height,
          padding: const EdgeInsets.all(15.0),
          child: child
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
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
                height: 100,
                child: const Text('Позвонить соседу')
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
          ]
        )
      )
    );
  }
}
