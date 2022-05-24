import 'package:dom24x7_flutter/pages/services/miniapps/url_miniapp.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class PIKComfortMiniApp extends StatefulWidget {
  const PIKComfortMiniApp({Key? key}) : super(key: key);

  @override
  State<PIKComfortMiniApp> createState() => _PIKComfortMiniAppState();
}

class _PIKComfortMiniAppState extends State<PIKComfortMiniApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(context, Utilities.getHeaderTitle('ПИК-Комфорт')),
        bottomNavigationBar: const Footer(FooterNav.services),
        body: const UrlMiniApp(
            url: 'https://new.pik-comfort.ru/'
        )
    );
  }
}
