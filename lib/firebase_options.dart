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
      return web;
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
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDFNxKAd7i1NXHD2X7ysXQYM__JmSpv5Tk',
    appId: '1:409783687607:web:0c980b6a1681ec64bab032',
    messagingSenderId: '409783687607',
    projectId: 'ft-tiktok-project',
    authDomain: 'ft-tiktok-project.firebaseapp.com',
    storageBucket: 'ft-tiktok-project.appspot.com',
    measurementId: 'G-1F49LD1VV4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfVupRFpkqTeaAHt56ngte47UnimDxWYQ',
    appId: '1:409783687607:android:8be3e336f06e3ff2bab032',
    messagingSenderId: '409783687607',
    projectId: 'ft-tiktok-project',
    storageBucket: 'ft-tiktok-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC75rs6oYk0GFPW8EzLhmnX6fyiGFLIaOs',
    appId: '1:409783687607:ios:9acd218ab8ba4c1bbab032',
    messagingSenderId: '409783687607',
    projectId: 'ft-tiktok-project',
    storageBucket: 'ft-tiktok-project.appspot.com',
    iosBundleId: 'com.example.tiktokClone',
  );
}
