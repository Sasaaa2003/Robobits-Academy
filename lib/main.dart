import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
