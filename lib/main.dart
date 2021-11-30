import 'package:dom24x7_flutter/pages/about_page.dart';
import 'package:dom24x7_flutter/pages/app_loader_screen_page.dart';
import 'package:dom24x7_flutter/pages/house_page.dart';
import 'package:dom24x7_flutter/pages/im_page.dart';
import 'package:dom24x7_flutter/pages/invite_page.dart';
import 'package:dom24x7_flutter/pages/news_page.dart';
import 'package:dom24x7_flutter/pages/profile_page.dart';
import 'package:dom24x7_flutter/pages/services_page.dart';
import 'package:dom24x7_flutter/pages/settings_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dom24x7',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/loader',
      routes: {
        '/loader': (context) => const AppLoaderScreenPage(),
        '/': (context) => const NewsPage(),
        '/house': (context) => const HousePage(),
        '/im': (context) => const IMPage(),
        '/services': (context) => const ServicesPage(),
        '/about': (context) => const AboutPage(),
        '/profile': (context) => const ProfilePage(),
        '/invite': (context) => const InvitePage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}