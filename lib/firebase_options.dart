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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnvoabATTdKu702_Z5q19Gt0Zfs4yOAj0',
    appId: '1:22052510911:android:512f1c6145b8fa69327a0a',
    messagingSenderId: '22052510911',
    projectId: 'playstage-dev',
    databaseURL:
        'https://playstage-dev-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'playstage-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8Xo77SyunTxmaCTlMb43XD3FMsGSpORE',
    appId: '1:22052510911:ios:e21e89eacb938306327a0a',
    messagingSenderId: '22052510911',
    projectId: 'playstage-dev',
    databaseURL:
        'https://playstage-dev-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'playstage-dev.appspot.com',
    iosClientId:
        '22052510911-5v6ero341ugv3h8u6rc0evucpvpj9ej1.apps.googleusercontent.com',
    iosBundleId: 'com.playstage.playstage',
  );
}
