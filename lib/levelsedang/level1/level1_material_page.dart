import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'level1_game_page.dart';

class SedangLevel1MaterialPage extends StatefulWidget {
  const SedangLevel1MaterialPage({super.key});

  @override
  State<SedangLevel1MaterialPage> createState() =>
      _SedangLevel1MaterialPageState();
}

class _SedangLevel1MaterialPageState extends State<SedangLevel1MaterialPage>
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

    // ===== AUTO PINDAH KE GAME LEVEL SEDANG 1 =====
    Future.delayed(const Duration(seconds: 15), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SedangLevel1GamePage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  // ===== LAMP =====
  Widget _lamp(bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Opacity(
        opacity: active ? 1 : 0.3,
        child: Image.asset(
          "assets/lamp.png",
          width: 18,
        ),
      ),
    );
  }

  // ===== IMAGE BUTTON =====
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
          // ===== BACKGROUND =====
          Image.asset(
            "assets/bg_network.png",
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
                          // REFRESH
                          _imageButton(
                            asset: "assets/refresh.png",
                            onTap: () {
                              setState(() {
                                lampCount = 0;
                              });
                            },
                          ),

                          const SizedBox(width: 8),

                          // PROGRESS
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
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
                                      Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // PAUSE
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

                    // ===== MATERIAL TEXT =====
                    Container(
                      height: 150,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      alignment: Alignment.topCenter,
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Di zona ini, RoboBits mempelajari bentuk sebagai struktur dasar."
                            "Logika membantu mengenali persamaan dan perbedaan bentuk rumah agar dapat diklasifikasikan dengan benar."
                            "Kemampuan ini penting untuk memahami struktur data.",
                            speed:
                                const Duration(milliseconds: 40),
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
