import 'package:dom24x7_flutter/pages/about_page.dart';
import 'package:dom24x7_flutter/pages/app_loader_screen_page.dart';
import 'package:dom24x7_flutter/pages/house_page.dart';
import 'package:dom24x7_flutter/pages/im/im_channels_page.dart';
import 'package:dom24x7_flutter/pages/invite_page.dart';
import 'package:dom24x7_flutter/pages/news_page.dart';
import 'package:dom24x7_flutter/pages/profile_page.dart';
import 'package:dom24x7_flutter/pages/sec_auth_page.dart';
import 'package:dom24x7_flutter/pages/sec_code_page.dart';
import 'package:dom24x7_flutter/pages/sec_reg_page.dart';
import 'package:dom24x7_flutter/pages/services/services_page.dart';
import 'package:dom24x7_flutter/pages/settings_page.dart';
import 'package:dom24x7_flutter/pages/spaces_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api/socket_client.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MainStore>(create: (_) {
          final store = MainStore();
          final SocketClient client = SocketClient(store);
          client.connect();
          store.setClient(client);
          return store;
        })
      ],
      child: MaterialApp(
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
          '/im': (context) => const IMChannelsPage(),
          '/services': (context) => const ServicesPage(),
          '/about': (context) => const AboutPage(),
          '/profile': (context) => const ProfilePage(),
          '/invite': (context) => const InvitePage(),
          '/settings': (context) => const SettingsPage(),
          '/spaces': (context) => const SpacesPage(),
          '/security/auth': (context) => const SecAuthPage(),
          '/security/reg': (context) => const SecRegPage(),
          '/security/code': (context) => const SecCodePage(),
        },
      )
    );
  }
}