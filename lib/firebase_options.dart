// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCVMg-o_0FlCaHtEzSJHtddYxvQC3EITTA',
    appId: '1:581476405635:web:f43df00cdad180f6a4e6b6',
    messagingSenderId: '581476405635',
    projectId: 'fir-flutter-login-68b44',
    authDomain: 'fir-flutter-login-68b44.firebaseapp.com',
    storageBucket: 'fir-flutter-login-68b44.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwGSK9TeTQ0pBeUYUNdlxhXD8-TlZBGHY',
    appId: '1:581476405635:android:fcbf0b161ba35f5ba4e6b6',
    messagingSenderId: '581476405635',
    projectId: 'fir-flutter-login-68b44',
    storageBucket: 'fir-flutter-login-68b44.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBojZIOgKA8YRYPP4Rtw6FOYEXMec7wv8U',
    appId: '1:581476405635:ios:d861fb0b2a2f15f6a4e6b6',
    messagingSenderId: '581476405635',
    projectId: 'fir-flutter-login-68b44',
    storageBucket: 'fir-flutter-login-68b44.appspot.com',
    iosBundleId: 'com.example.idiomJourney',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBojZIOgKA8YRYPP4Rtw6FOYEXMec7wv8U',
    appId: '1:581476405635:ios:d861fb0b2a2f15f6a4e6b6',
    messagingSenderId: '581476405635',
    projectId: 'fir-flutter-login-68b44',
    storageBucket: 'fir-flutter-login-68b44.appspot.com',
    iosBundleId: 'com.example.idiomJourney',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCVMg-o_0FlCaHtEzSJHtddYxvQC3EITTA',
    appId: '1:581476405635:web:5aa2fa37097f048ba4e6b6',
    messagingSenderId: '581476405635',
    projectId: 'fir-flutter-login-68b44',
    authDomain: 'fir-flutter-login-68b44.firebaseapp.com',
    storageBucket: 'fir-flutter-login-68b44.appspot.com',
  );
}
