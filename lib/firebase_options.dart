// TODO Implement this library.
// firebase_options.dart (сгенерированный файл после flutterfire configure)
// ⚠️ Этот файл должен быть сгенерирован автоматически.
// Если он ещё не создан — выполни команду:
// flutterfire configure

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions не поддерживает этот таргет: $defaultTargetPlatform',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCvbfs5-HvEJgE4Dz4YFJJZBmPQ9JODE8',
    appId: '1:656060445711:android:4b57c9542393752ffbdf7a',
    messagingSenderId: '656060445711',
    projectId: 'shop-95c60',
    storageBucket: 'shop-95c60.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCvbfs5-HvEJgE4Dz4YFJJZBmPQ9JODE8',
    appId: '1:656060445711:android:4b57c9542393752ffbdf7a',
    messagingSenderId: '656060445711',
    projectId: 'shop-95c60',
    storageBucket: 'shop-95c60.firebasestorage.app',
    iosBundleId: 'com.example.shopm',
  );
}
