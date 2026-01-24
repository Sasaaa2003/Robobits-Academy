import 'dart:async';
import 'package:flutter/material.dart';
import 'level1_material_page.dart';
import 'package:robobits/audio/level1_bgm.dart';

class SedangLevel1IntroPage extends StatefulWidget {
  const SedangLevel1IntroPage({super.key});

  @override
  State<SedangLevel1IntroPage> createState() =>
      _SedangLevel1IntroPageState();
}

class _SedangLevel1IntroPageState extends State<SedangLevel1IntroPage>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _rotateController;
  late AnimationController _floatController;

  late Animation<double> _entryAnim;
  late Animation<double> _rotateAnim;
  late Animation<double> _floatAnim;

  bool _showText = false;

  @override
  void initState() {
    super.initState();

    // 🔊 BGM DISAMAKAN DENGAN LEVEL MUDAH
    Level1Bgm.play();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _entryAnim = Tween<double>(begin: -300, end: 0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );

    _rotateAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    _floatAnim = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    // Robot turun
    await _entryController.forward();

    // Muter sekali
    await _rotateController.forward();

    // Melayang idle
    _floatController.repeat(reverse: true);

    // Teks muncul
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => _showText = true);

    // ⏳ Waktu baca teks
    await Future.delayed(const Duration(seconds: 4));

    // ➡️ Pindah ke material Level Sedang 1
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SedangLevel1MaterialPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _rotateController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ===== BACKGROUND =====
          Image.asset(
            "assets/bg_network.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _entryController,
                    _rotateController,
                    _floatController,
                  ]),
                  builder: (_, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        _entryAnim.value - _floatAnim.value,
                      ),
                      child: Transform.rotate(
                        angle: _rotateAnim.value * 3.14 * 2,
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset(
                    "assets/robot.png",
                    height: 140,
                  ),
                ),

                const SizedBox(height: 30),

                AnimatedOpacity(
                  opacity: _showText ? 1 : 0,
                  duration: const Duration(milliseconds: 800),
                  child: const Text(
                    "Selamat datang di Zona Konstruksi Data\n"
                    "Setiap bentuk memiliki fungsi.\n",
                    
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
