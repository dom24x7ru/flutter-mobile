import 'package:dom24x7_flutter/pages/services/miniapps/url_miniapp.dart';
import 'package:dom24x7_flutter/utilities.dart';
import 'package:dom24x7_flutter/widgets/footer_widget.dart';
import 'package:dom24x7_flutter/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class A3MiniApp extends StatefulWidget {
  const A3MiniApp({Key? key}) : super(key: key);

  @override
  State<A3MiniApp> createState() => _A3MiniAppState();
}

class _A3MiniAppState extends State<A3MiniApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(context, Utilities.getHeaderTitle('Коммунальные платежи')),
        bottomNavigationBar: const Footer(FooterNav.services),
        body: const UrlMiniApp(
            url: 'https://www.a-3.ru/'
        )
    );
  }
}
