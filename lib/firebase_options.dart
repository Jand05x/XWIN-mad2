import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBo5rxW99s2HHB9klHBP2u_GDLpWvJbiI',
    appId: '1:677104751369:android:fc1bb5085ff4bd2e2bb9d8',
    messagingSenderId: '677104751369',
    projectId: 'xwin2-40f87',
    storageBucket: 'xwin2-40f87.firebasestorage.app',
  );
}
