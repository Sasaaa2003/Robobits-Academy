import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null,
    );
  } catch (e) {
    debugPrint("Firebase already initialized");
  }

  runApp(const RobobitsApp());
}

class RobobitsApp extends StatelessWidget {
  const RobobitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Robobits',
      theme: ThemeData(
        fontFamily: 'MochiyPopOne',
      ),
      home: const SplashPage(),
    );
  }
}
