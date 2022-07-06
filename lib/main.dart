import 'package:dom24x7_flutter/models/house/flat.dart';
import 'package:dom24x7_flutter/models/house/flat_type.dart';
import 'package:dom24x7_flutter/models/house/resident.dart';
import 'package:dom24x7_flutter/models/house/resident_extra.dart';
import 'package:dom24x7_flutter/models/im/im_channel.dart';
import 'package:dom24x7_flutter/models/im/im_image.dart';
import 'package:dom24x7_flutter/models/im/im_message.dart';
import 'package:dom24x7_flutter/models/im/im_message_body.dart';
import 'package:dom24x7_flutter/models/im/im_message_extra.dart';
import 'package:dom24x7_flutter/models/im/im_message_history_item.dart';
import 'package:dom24x7_flutter/models/im/im_person.dart';
import 'package:dom24x7_flutter/models/miniapp/miniapp.dart';
import 'package:dom24x7_flutter/models/miniapp/miniapp_extra.dart';
import 'package:dom24x7_flutter/models/miniapp/miniapp_type.dart';
import 'package:dom24x7_flutter/models/post.dart';
import 'package:dom24x7_flutter/models/user/contact_access.dart';
import 'package:dom24x7_flutter/models/user/enums/level.dart';
import 'package:dom24x7_flutter/models/user/enums/name_format.dart';
import 'package:dom24x7_flutter/models/user/name_access.dart';
import 'package:dom24x7_flutter/models/user/person.dart';
import 'package:dom24x7_flutter/models/user/person_access.dart';
import 'package:dom24x7_flutter/models/user/role.dart';
import 'package:dom24x7_flutter/models/user/user.dart';
import 'package:dom24x7_flutter/models/vote/vote.dart';
import 'package:dom24x7_flutter/models/vote/vote_answer.dart';
import 'package:dom24x7_flutter/models/vote/vote_question.dart';
import 'package:dom24x7_flutter/pages/about_page.dart';
import 'package:dom24x7_flutter/pages/app_loader_screen_page.dart';
import 'package:dom24x7_flutter/pages/feedback_page.dart';
import 'package:dom24x7_flutter/pages/house/house_page.dart';
import 'package:dom24x7_flutter/pages/im/im_channels_page.dart';
import 'package:dom24x7_flutter/pages/security/invite_page.dart';
import 'package:dom24x7_flutter/pages/news_page.dart';
import 'package:dom24x7_flutter/pages/profile/profile_page.dart';
import 'package:dom24x7_flutter/pages/security/sec_auth_page.dart';
import 'package:dom24x7_flutter/pages/security/sec_code_page.dart';
import 'package:dom24x7_flutter/pages/security/sec_reg_page.dart';
import 'package:dom24x7_flutter/pages/services/services_page.dart';
import 'package:dom24x7_flutter/pages/profile/settings_page.dart';
import 'package:dom24x7_flutter/pages/profile/spaces_page.dart';
import 'package:dom24x7_flutter/store/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'api/socket_client.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint("Handling a background message: ${message.messageId}");
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
  debugPrint('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint('Message also contained a notification: ${message.notification}');
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(RoleAdapter());
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(PersonAccessAdapter());
  Hive.registerAdapter(NameAccessAdapter());
  Hive.registerAdapter(LevelAdapter());
  Hive.registerAdapter(NameFormatAdapter());
  Hive.registerAdapter(ContactAccessAdapter());
  Hive.registerAdapter(ResidentAdapter());
  Hive.registerAdapter(ResidentExtraAdapter());
  Hive.registerAdapter(FlatAdapter());
  Hive.registerAdapter(FlatTypeAdapter());
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(IMChannelAdapter());
  Hive.registerAdapter(IMMessageAdapter());
  Hive.registerAdapter(IMMessageBodyAdapter());
  Hive.registerAdapter(IMMessageExtraAdapter());
  Hive.registerAdapter(IMMessageHistoryItemAdapter());
  Hive.registerAdapter(IMPersonAdapter());
  Hive.registerAdapter(IMImageAdapter());
  Hive.registerAdapter(VoteAdapter());
  Hive.registerAdapter(VoteQuestionAdapter());
  Hive.registerAdapter(VoteAnswerAdapter());
  Hive.registerAdapter(MiniAppAdapter());
  Hive.registerAdapter(MiniAppTypeAdapter());
  Hive.registerAdapter(MiniAppExtraAdapter());

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
          '/feedback': (context) => const FeedbackPage(),
          '/security/auth': (context) => const SecAuthPage(),
          '/security/reg': (context) => const SecRegPage(),
          '/security/code': (context) => const SecCodePage(),
        },
      )
    );
  }
}