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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCLG9ZPqn4GSWKqb_dvgNGxVuUuVxZgCVU',
    appId: '1:2841186709:web:4594d2bd34ca97f10c669c',
    messagingSenderId: '2841186709',
    projectId: 'duyguya-gore-muzik',
    authDomain: 'duyguya-gore-muzik.firebaseapp.com',
    storageBucket: 'duyguya-gore-muzik.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPofuC3K3Otw07AHdLFL88frDc2_6xhUY',
    appId: '1:2841186709:android:f9b3c05632b868c10c669c',
    messagingSenderId: '2841186709',
    projectId: 'duyguya-gore-muzik',
    storageBucket: 'duyguya-gore-muzik.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgKigWvTbZ_JNiTExcvObCIEZPeO-1AeQ',
    appId: '1:2841186709:ios:6594ebc0c2fe96cb0c669c',
    messagingSenderId: '2841186709',
    projectId: 'duyguya-gore-muzik',
    storageBucket: 'duyguya-gore-muzik.appspot.com',
    iosBundleId: 'com.example.duyguDurumunaGoreMuzikOneriSistemi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCLG9ZPqn4GSWKqb_dvgNGxVuUuVxZgCVU',
    appId: '1:2841186709:web:9040f684dbef427c0c669c',
    messagingSenderId: '2841186709',
    projectId: 'duyguya-gore-muzik',
    authDomain: 'duyguya-gore-muzik.firebaseapp.com',
    storageBucket: 'duyguya-gore-muzik.appspot.com',
  );
}