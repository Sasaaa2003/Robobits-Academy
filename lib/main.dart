import 'package:flutter/material.dart';
import 'splash_page.dart';

void main() {
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
