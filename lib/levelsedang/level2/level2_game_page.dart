import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:robobits/audio/level1_bgm.dart';
import 'package:robobits/level_sedang_page.dart';
import 'package:robobits/levelsedang/level2/level2_result_dialog.dart';

enum ShapeType { star, circle, square, triangle }

class ShapeQuestion {
  final ShapeType shape;
  final int answer;
  final List<int> options;
  bool isCorrect;

  ShapeQuestion({
    required this.shape,
    required this.answer,
    required this.options,
    this.isCorrect = false,
  });
}

class SedangLevel2GamePage extends StatefulWidget {
  const SedangLevel2GamePage({super.key});

  @override
  State<SedangLevel2GamePage> createState() => _SedangLevel2GamePageState();
}

class _SedangLevel2GamePageState extends State<SedangLevel2GamePage> {
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool showCemas = false;
  int lampCount = 0;

  late final List<ShapeType> shapes;
  late final List<ShapeQuestion> questions;

  @override
  void initState() {
    super.initState();

    shapes = [
      ...List.filled(1, ShapeType.circle),
      ...List.filled(4, ShapeType.star),
      ...List.filled(3, ShapeType.triangle),
      ...List.filled(2, ShapeType.square),
    ]..shuffle(Random());

    questions = [
      _buildQuestion(ShapeType.circle, 1),
      _buildQuestion(ShapeType.star, 4),
      _buildQuestion(ShapeType.triangle, 3),
      _buildQuestion(ShapeType.square, 2),
    ];
  }

  ShapeQuestion _buildQuestion(ShapeType shape, int answer) {
    final rand = Random();
    final set = <int>{answer};

    while (set.length < 3) {
      set.add(rand.nextInt(9) + 1);
    }

    return ShapeQuestion(
      shape: shape,
      answer: answer,
      options: set.toList()..shuffle(rand),
    );
  }

  String get robotAsset =>
      showCemas ? "assets/cemas.png" : "assets/robot.png";

  // ================= CHECK =================
  Future<void> check(int value, ShapeQuestion q) async {
    if (q.isCorrect) return;

    if (value == q.answer) {
      await _sfxPlayer.play(AssetSource('Audios/correct.mp3'));
      setState(() {
        q.isCorrect = true;
        lampCount++;
      });

      if (lampCount == questions.length) {
        await Level1Bgm.stop();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const SedangLevel2ResultDialog(score: 300),
        );
      }
    } else {
      await _sfxPlayer.play(AssetSource('Audios/wrong.mp3'));
      setState(() => showCemas = true);
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => showCemas = false);
      });
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/bg_network.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 80),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.70),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _topBar(),
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Image.asset(robotAsset, height: 80),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Beberapa bentuk rumah tampil bersamaan.\n"
                            "Sistem meminta jumlah bentuk tertentu untuk verifikasi.",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _shapeBoard(),
                    const SizedBox(height: 12),

                    Expanded(
                      child: Column(
                        children: questions.map(_answerRow).toList(),
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
                await _sfxPlayer.play(AssetSource('Audios/click.wav'));
                await Level1Bgm.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LevelSedangPage()),
                );
              },
              child: Image.asset("assets/btn back.png", width: 50),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TOP BAR =================
  Widget _topBar() => Padding(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (i) => _lamp(lampCount > i),
                      ),
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: lampCount / 4,
                      minHeight: 6,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Image.asset("assets/jeda.png", width: 36),
          ],
        ),
      );

  Widget _lamp(bool active) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Opacity(
          opacity: active ? 1 : 0.3,
          child: Image.asset("assets/lamp.png", width: 18),
        ),
      );

  // ================= PAPAN =================
  Widget _shapeBoard() => Container(
        width: 260,
        height: 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE6E6E6),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          children: shapes.map(_buildShape).toList(),
        ),
      );

  // ================= JAWABAN =================
  Widget _answerRow(ShapeQuestion q) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Center(child: _buildQuestionIcon(q.shape)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: q.options.map((n) {
                  return _answerButton(
                    value: n,
                    question: q,
                    onTap: () => check(n, q),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );

  Widget _answerButton({
    required int value,
    required ShapeQuestion question,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: question.isCorrect ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: question.isCorrect
              ? null
              : const LinearGradient(
                  colors: [Color(0xFF7FB2FF), Color(0xFF4F8BFF)],
                ),
          color: question.isCorrect ? Colors.green : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ================= ICON =================
  Widget _buildQuestionIcon(ShapeType shape) {
    switch (shape) {
      case ShapeType.star:
        return const Icon(Icons.star, size: 32, color: Colors.deepPurple);
      case ShapeType.circle:
        return Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        );
      case ShapeType.square:
        return Container(width: 28, height: 28, color: Colors.red);
      case ShapeType.triangle:
        return const Icon(Icons.change_history,
            size: 32, color: Colors.green);
    }
  }

  Widget _buildShape(ShapeType type) {
    switch (type) {
      case ShapeType.star:
        return const Icon(Icons.star, size: 34, color: Colors.deepPurple);
      case ShapeType.circle:
        return Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        );
      case ShapeType.square:
        return Container(color: Colors.red);
      case ShapeType.triangle:
        return const Icon(Icons.change_history,
            size: 34, color: Colors.green);
    }
  }
}
