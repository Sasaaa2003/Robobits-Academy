import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'level2_game_page.dart';

class Level2MaterialPage extends StatefulWidget {
  const Level2MaterialPage({super.key});

  @override
  State<Level2MaterialPage> createState() => _Level2MaterialPageState();
}

class _Level2MaterialPageState extends State<Level2MaterialPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  int lampCount = 0;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // ===== AUTO PINDAH KE GAME LEVEL 2 =====
    Future.delayed(const Duration(seconds: 15), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Level2GamePage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  Widget _lamp(bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Opacity(
        opacity: active ? 1 : 0.3,
        child: Image.asset("assets/lamp.png", width: 18),
      ),
    );
  }

  Widget _imageButton({
    required String asset,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        asset,
        width: 36,
        height: 36,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/bg_compile.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.46),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // ===== TOP BAR =====
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _imageButton(
                            asset: "assets/refresh.png",
                            onTap: () {
                              setState(() {
                                lampCount = 0;
                              });
                            },
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4C79C5),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _lamp(lampCount >= 1),
                                      _lamp(lampCount >= 2),
                                      _lamp(lampCount >= 3),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  LinearProgressIndicator(
                                    value: lampCount / 3,
                                    minHeight: 6,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.3),
                                    valueColor:
                                        const AlwaysStoppedAnimation(
                                            Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          _imageButton(
                            asset: "assets/jeda.png",
                            onTap: () {
                              if (_floatController.isAnimating) {
                                _floatController.stop();
                              } else {
                                _floatController.repeat(reverse: true);
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ===== ROBOT =====
                    AnimatedBuilder(
                      animation: _floatAnim,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(0, -_floatAnim.value),
                        child: child,
                      ),
                      child: Image.asset(
                        "assets/robot.png",
                        height: 95,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ===== TEXT MATERIAL LEVEL 2 =====
                    Container(
                      height: 150,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      alignment: Alignment.topCenter,
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Sekarang kita belajar menghitung.\n\n"
                            "Perhatikan jumlah monitor yang muncul "
                            "di layar dengan baik.\n\n"
                            "Hitung satu per satu "
                            "agar tidak salah memilih jawaban.",
                            speed: const Duration(milliseconds: 40),
                            cursor: "|",
                            textAlign: TextAlign.center,
                            textStyle: const TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                  
                    

                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
