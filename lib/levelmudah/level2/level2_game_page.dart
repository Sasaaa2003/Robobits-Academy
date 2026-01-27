import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'level2_result_dialog.dart';
import 'package:robobits/level_mudah_page.dart';
import 'package:robobits/audio/level1_bgm.dart';

class Level2GamePage extends StatefulWidget {
  const Level2GamePage({super.key});

  @override
  State<Level2GamePage> createState() => _Level2GamePageState();
}

class _Level2GamePageState extends State<Level2GamePage> {
  int lampCount = 0;
  bool isPaused = false;
  bool _showCemas = false;

  final AudioPlayer _sfxPlayer = AudioPlayer();

  // ===== JAWABAN BENAR =====
  final int correctAnswer = 3;

  String get _robotAsset =>
      _showCemas ? "assets/cemas.png" : "assets/robot.png";

  // ===== GAMBAR =====
  final List<String> items = [
    "assets/monitor.png",
    "assets/tv.png",
    "assets/monitor.png",
    "assets/tablet.png",
    "assets/tv.png",
    "assets/tablet.png",
    "assets/monitor.png",
    "assets/tablet.png",
    "assets/tv.png",
    "assets/tablet.png",
    "assets/tv.png",
    "assets/tablet.png",
  ];

  void _showBubble() {
    setState(() => _showCemas = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _showCemas = false);
    });
  }

  Future<void> _onAnswerTap(int answer) async {
    if (isPaused) return;

    if (answer == correctAnswer) {
      await _playCorrectSound();
      setState(() => lampCount = 3);
      await Level1Bgm.stop();

      Future.delayed(const Duration(milliseconds: 400), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Level2ResultDialog(score: 300),
        );
      });
    } else {
      await _playWrongSound();
      _showBubble();
    }
  }

  Future<void> _playCorrectSound() async {
    await _sfxPlayer.stop();
    await _sfxPlayer.play(
      AssetSource('Audios/correct.mp3'),
      volume: 1.0,
    );
  }

  Future<void> _playWrongSound() async {
    await _sfxPlayer.stop();
    await _sfxPlayer.play(
      AssetSource('Audios/wrong.mp3'),
      volume: 1.0,
    );
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

  Widget _bubbleToast() {
    if (!_showCemas) return const SizedBox();

    return Positioned(
      top: 92,
      left: 105,
      child: AnimatedScale(
        scale: _showCemas ? 1 : 0.8,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F2),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: const Text(
            "Coba hitung lagi ya!",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sfxPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ===== BACKGROUND =====
          Image.asset(
            "assets/bg_compile.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // ===== CONTENT =====
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 80),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.46),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Stack(
                  children: [
                    Column(
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

                        const SizedBox(height: 18),

                        // ===== ROBOT + TEKS =====
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Image.asset(
                                  _robotAsset,
                                  key: ValueKey(_robotAsset),
                                  height: 75,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "Beberapa monitor aktif bersamaan.\n"
                                  "Sistem meminta jumlah yang tepat untuk sinkronisasi.\n\n"
                                  "Tugasmu:\nHitung berapa jumlah monitor!",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== GRID GAMBAR =====
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(12),
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              return Center(
                                child: Image.asset(
                                  items[index],
                                  height: 70,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ===== TOMBOL JAWABAN =====
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [2, 3, 4].map((num) {
                            return GestureDetector(
                              onTap: () => _onAnswerTap(num),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                width: 70,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4C79C5),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "$num",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),

                    _bubbleToast(),
                  ],
                ),
              ),
            ),
          ),

          // ===== BACK BUTTON (PATOKAN FINAL) =====
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
                    builder: (_) => const LevelMudahPage(),
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
