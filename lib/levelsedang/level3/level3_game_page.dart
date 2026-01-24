import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:robobits/audio/level1_bgm.dart';
import 'level3_result_dialog.dart';
import 'package:robobits/level_sedang_page.dart';

class SedangLevel3GamePage extends StatefulWidget {
  const SedangLevel3GamePage({super.key});

  @override
  State<SedangLevel3GamePage> createState() => _SedangLevel3GamePageState();
}

class _SedangLevel3GamePageState extends State<SedangLevel3GamePage> {
  final AudioPlayer _sfxPlayer = AudioPlayer();

  // ===== LAMP =====
  int lampCount = 0;

  // ===== ROBOT DATA =====
  final List<int> robots = [1, 2, 3, 4, 5]; // 1 pendek - 5 tinggi
  final List<int?> answers = List.filled(5, null);

  @override
  void initState() {
    super.initState();
    robots.shuffle();
    Level1Bgm.play();
  }

  double robotSize(int level) {
    switch (level) {
      case 1:
        return 38;
      case 2:
        return 48;
      case 3:
        return 58;
      case 4:
        return 68;
      case 5:
        return 78;
      default:
        return 50;
    }
  }

  void _checkAnswer() async {
    const correct = [5, 4, 3, 2, 1];
    bool isCorrect = true;

    for (int i = 0; i < 5; i++) {
      if (answers[i] != correct[i]) {
        isCorrect = false;
        break;
      }
    }

    setState(() => lampCount = isCorrect ? 3 : 1);

    if (isCorrect) {
      await Level1Bgm.stop();
      Future.delayed(const Duration(milliseconds: 400), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const SedangLevel3ResultDialog(score: 300),
        );
      });
    }
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

  Widget _robotDrag(int level) {
    return Draggable<int>(
      data: level,
      feedback: Material(
        color: Colors.transparent,
        child: Image.asset(
          "assets/Robo2.png",
          width: robotSize(level),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Image.asset(
          "assets/Robo2.png",
          width: robotSize(level),
        ),
      ),
      child: Image.asset(
        "assets/Robo2.png",
        width: robotSize(level),
      ),
    );
  }

  Widget _answerBox(int index) {
    return DragTarget<int>(
      onAccept: (data) async {
        await _sfxPlayer.play(AssetSource('Audios/click.wav'));
        setState(() {
          answers[index] = data;
          lampCount = 2;
        });
      },
      builder: (_, __, ___) {
        return Container(
          width: 50,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26),
          ),
          alignment: Alignment.center,
          child: answers[index] != null
              ? Image.asset(
                  "assets/Robo2.png",
                  width: robotSize(answers[index]!),
                )
              : const SizedBox(width: 20),
        );
      },
    );
  }

  @override
  void dispose() {
    _sfxPlayer.dispose();
    Level1Bgm.stop();
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

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 80),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.80),
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
                          Image.asset("assets/refresh.png", width: 36),
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
                                            Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Image.asset("assets/jeda.png", width: 36),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===== INSTRUKSI =====
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/robot.png", width: 80),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "Robot-robot berdiri dengan tinggi yang berbeda."
                              "Sistem menunggu susunan yang tepat agar jalur produksi dapat berjalan."
                              "Urutkan robot dari paling tinggi\n"
                              "ke paling pendek dengan\n"
                              "cara drag & drop!",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // ===== ROBOT DRAG =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: robots.map(_robotDrag).toList(),
                    ),

                    const SizedBox(height: 16),

                    // ===== ANSWER BOX =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: _answerBox(i),
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),

                    // ===== CEK =====
                    ElevatedButton(
                      onPressed: _checkAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C79C5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Cek Jawaban",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            child: GestureDetector(
              onTap: () async {
                await _sfxPlayer.play(
                  AssetSource('Audios/click.wav'),
                );
                await Level1Bgm.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LevelSedangPage(),
                  ),
                );
              },
              child: Image.asset(
                "assets/btn back.png",
                width: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
