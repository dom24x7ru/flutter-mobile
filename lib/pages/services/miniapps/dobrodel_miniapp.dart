import 'package:dom24x7_flutter/pages/services/miniapps/url_miniapp.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class DobrodelMiniApp extends StatefulWidget {
  const DobrodelMiniApp({Key? key}) : super(key: key);

  @override
  State<DobrodelMiniApp> createState() => _DobrodelMiniAppState();
}

class _DobrodelMiniAppState extends State<DobrodelMiniApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(context, Utilities.getHeaderTitle('Добродел')),
      bottomNavigationBar: const Footer(FooterNav.services),
      body: const UrlMiniApp(
        url: 'https://dobrodel.mosreg.ru/'
      )
    );
  }
}
