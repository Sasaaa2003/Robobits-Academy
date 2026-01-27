import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        return web;
    }
  }

  // 🔹 ANDROID
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBbaAe9U2bKC-ImiW1FloAU4ZWYoIP5kPM",
    appId: "1:296401790469:android:229a646d30bfed776b5e6c",
    messagingSenderId: "296401790469",
    projectId: "robobits-4118c",
    storageBucket: "robobits-4118c.appspot.com",
  );

  // 🔹 WEB
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBbaAe9U2bKC-ImiW1FloAU4ZWYoIP5kPM",
    authDomain: "robobits-4118c.firebaseapp.com",
    projectId: "robobits-4118c",
    storageBucket: "robobits-4118c.appspot.com",
    messagingSenderId: "296401790469",
    appId: "1:296401790469:web:27d6f50469e0db6e6b5e6c",
  );

  // 🔹 IOS (boleh sementara samakan dengan android)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBbaAe9U2bKC-ImiW1FloAU4ZWYoIP5kPM",
    appId: "1:296401790469:android:229a646d30bfed776b5e6c",
    messagingSenderId: "296401790469",
    projectId: "robobits-4118c",
    storageBucket: "robobits-4118c.appspot.com",
  );
}
