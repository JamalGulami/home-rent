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
        return macos;
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
    apiKey: 'AIzaSyAtLLMFXsD4_YeLJHxViWppKj0TSgZBVUg',
    appId: '1:706434463587:web:5a0a5cf7a9365dfb878556',
    messagingSenderId: '706434463587',
    projectId: 'jamal-rahnamaei',
    authDomain: 'jamal-rahnamaei.firebaseapp.com',
    storageBucket: 'jamal-rahnamaei.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAmGHLO-vaP7tCiRDPVQS7gMJUEekH6Jjs',
    appId: '1:706434463587:android:95178c011f54aa16878556',
    messagingSenderId: '706434463587',
    projectId: 'jamal-rahnamaei',
    storageBucket: 'jamal-rahnamaei.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIh6zLTdlyWVPY8Wl7ZEII1OtEqDKDdkI',
    appId: '1:706434463587:ios:bea29a05ad2a11b2878556',
    messagingSenderId: '706434463587',
    projectId: 'jamal-rahnamaei',
    storageBucket: 'jamal-rahnamaei.appspot.com',
    iosBundleId: 'com.jamalapp.jamalRahnamaie',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCIh6zLTdlyWVPY8Wl7ZEII1OtEqDKDdkI',
    appId: '1:706434463587:ios:786ba988dfb30d29878556',
    messagingSenderId: '706434463587',
    projectId: 'jamal-rahnamaei',
    storageBucket: 'jamal-rahnamaei.appspot.com',
    iosBundleId: 'com.jamalapp.jamalRahnamaie.RunnerTests',
  );
}
