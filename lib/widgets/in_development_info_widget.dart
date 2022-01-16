import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InDevelopmentInfo extends StatelessWidget {
  const InDevelopmentInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Раздел находится в разработке'),
              const Text('Доступен пока только в веб версии'),
              TextButton(
                onPressed: () => launch('https://m.dom24x7.ru/'),
                child: const Text('m.dom24x7.ru'),
              )
            ]
        )
    );
  }
}
