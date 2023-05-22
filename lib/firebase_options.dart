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
    apiKey: 'AIzaSyB_aWtpP4lmaYb4mAEIMDtA0a8x8uoSX7w',
    appId: '1:521732512335:web:5394fbf412f835afd4683a',
    messagingSenderId: '521732512335',
    projectId: 'pawfection-c14ed',
    authDomain: 'pawfection-c14ed.firebaseapp.com',
    storageBucket: 'pawfection-c14ed.appspot.com',
    measurementId: 'G-SXXCT2XXWR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGumxUe17MfInqYDcUhYioFpd8aNeI73U',
    appId: '1:521732512335:android:780eb0f59741e153d4683a',
    messagingSenderId: '521732512335',
    projectId: 'pawfection-c14ed',
    storageBucket: 'pawfection-c14ed.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCR94-DB193krdyaiuwdlV7mBqy_wLEMsA',
    appId: '1:521732512335:ios:d80d66dc88632c8bd4683a',
    messagingSenderId: '521732512335',
    projectId: 'pawfection-c14ed',
    storageBucket: 'pawfection-c14ed.appspot.com',
    iosClientId:
        '521732512335-gv30q6f1j1vc0sljq1tucihn5v86ftvg.apps.googleusercontent.com',
    iosBundleId: 'com.example.pawfection',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCR94-DB193krdyaiuwdlV7mBqy_wLEMsA',
    appId: '1:521732512335:ios:a2f1352f1fac2030d4683a',
    messagingSenderId: '521732512335',
    projectId: 'pawfection-c14ed',
    storageBucket: 'pawfection-c14ed.appspot.com',
    iosClientId:
        '521732512335-v467jlsp67nmippko80fri73l9mua3cb.apps.googleusercontent.com',
    iosBundleId: 'com.example.pawfection.RunnerTests',
  );
}
