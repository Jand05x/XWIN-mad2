import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    return android;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDFHu-DOItcroStX_6Xmb1XsEFtHIcjaLU',
    authDomain: 'xwin2-40f87.firebaseapp.com',
    appId: '1:677104751369:web:e8e02c89fec8173d2bb9d8',
    messagingSenderId: '677104751369',
    projectId: 'xwin2-40f87',
    storageBucket: 'xwin2-40f87.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBo5rxW99s2HHB9klHBP2u_GDLpWvJbiI',
    appId: '1:677104751369:android:fc1bb5085ff4bd2e2bb9d8',
    messagingSenderId: '677104751369',
    projectId: 'xwin2-40f87',
    storageBucket: 'xwin2-40f87.firebasestorage.app',
  );
}