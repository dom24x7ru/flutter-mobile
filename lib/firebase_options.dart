// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTGcU5BaIzxOgeoPskte-w8-LEVHZ3218',
    appId: '1:631025425076:android:848a0ade63412c973ed5e1',
    messagingSenderId: '631025425076',
    projectId: 'dom24x7-f28f7',
    databaseURL: 'https://dom24x7-f28f7.firebaseio.com',
    storageBucket: 'dom24x7-f28f7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCiw86wkF68HwURZpH5Ohet0Ib5Rz6NoXk',
    appId: '1:631025425076:ios:4203138128ca1baf3ed5e1',
    messagingSenderId: '631025425076',
    projectId: 'dom24x7-f28f7',
    databaseURL: 'https://dom24x7-f28f7.firebaseio.com',
    storageBucket: 'dom24x7-f28f7.appspot.com',
    iosClientId: '631025425076-nkphb669agjqjl5sc4odjb11lal2vl7j.apps.googleusercontent.com',
    iosBundleId: 'ru.dom24x7.flutter',
  );
}
