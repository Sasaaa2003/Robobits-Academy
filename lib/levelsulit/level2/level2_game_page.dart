import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:robobits/audio/level1_bgm.dart';
import 'level2_result_dialog.dart';
import 'package:robobits/level_sulit_page.dart';

const int totalLamp = 4;

class SulitLevel2GamePage extends StatefulWidget {
  final String username;
  const SulitLevel2GamePage({super.key, required this.username});

  @override
  State<SulitLevel2GamePage> createState() => _SulitLevel2GamePageState();
}

class _SulitLevel2GamePageState extends State<SulitLevel2GamePage> {
  final AudioPlayer _clickPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  int lampCount = 0;
  bool _showCemas = false;
  int? selectedIndex;

  late List<int?> honeyNumbers;
  final Map<int, int> correctAnswer = {};

  @override
  void initState() {
    super.initState();
    Level1Bgm.play();
    _generatePuzzle();
  }

  void _generatePuzzle() {
    honeyNumbers = List.generate(10, (i) => i + 1);
    final rand = Random();
    final emptyIndexes = <int>{};

    while (emptyIndexes.length < totalLamp) {
      emptyIndexes.add(rand.nextInt(9));
    }

    for (final i in emptyIndexes) {
      correctAnswer[i] = honeyNumbers[i]!;
      honeyNumbers[i] = null;
    }
  }

  Future<void> _playCorrect() async {
    await _effectPlayer.stop();
    await _effectPlayer.play(AssetSource('Audios/correct.mp3'));
  }

  Future<void> _playWrong() async {
    await _effectPlayer.stop();
    await _effectPlayer.play(AssetSource('Audios/wrong.mp3'));
  }

  void _showBubble() {
    setState(() => _showCemas = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showCemas = false);
    });
  }

  void _inputNumber(int value) async {
    if (selectedIndex == null) return;

    if (correctAnswer[selectedIndex!] == value) {
      setState(() {
        honeyNumbers[selectedIndex!] = value;
        selectedIndex = null;
        lampCount++;
      });
      await _playCorrect();

      if (lampCount == totalLamp) {
        Level1Bgm.stop();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => SulitLevel2ResultDialog(score: 600, username: widget.username),
        );
      }
    } else {
      await _playWrong();
      _showBubble();
    }
  }

  @override
  void dispose() {
    _clickPlayer.dispose();
    _effectPlayer.dispose();
    Level1Bgm.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double hexSize = screenWidth < 360 ? 52 : 62;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/bg_chips.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                25,
                25,
                25,
                MediaQuery.of(context).padding.bottom + 70,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildTopBar(),
                    const SizedBox(height: 16),
                    _buildRobotText(),
                    const SizedBox(height: 16),

                    /// === SCROLL AREA ===
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildHoneyComb(hexSize),
                                  const SizedBox(height: 30),
                                  _buildNumberPad(),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                        },
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
                await _clickPlayer.play(AssetSource('Audios/click.wav'));
                Level1Bgm.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LevelSulitPage(username: widget.username)),
                );
              },
              child: Image.asset("assets/btn back.png", width: 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRobotText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset(
            _showCemas ? "assets/cemas.png" : "assets/robot.png",
            height: 75,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Deretan angka muncul, tetapi beberapa bagian hilang.\n"
              "Sistem menunggu angka yang tepat untuk melanjutkan proses.\n"
              "Lengkapi angka pada sarang lebah!",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset("assets/refresh.png", width: 36),
          const SizedBox(width: 10),
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
                      totalLamp,
                      (i) => Opacity(
                        opacity: i < lampCount ? 1 : 0.3,
                        child:
                            Image.asset("assets/lamp.png", width: 22),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: lampCount / totalLamp,
                    minHeight: 6,
                    backgroundColor:
                        Colors.white.withOpacity(0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                            Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Image.asset("assets/jeda.png", width: 36),
        ],
      ),
    );
  }

  Widget _buildHoneyComb(double size) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: List.generate(honeyNumbers.length, (i) {
          final value = honeyNumbers[i];
          final isSelected = selectedIndex == i;

          return GestureDetector(
            onTap: value == null
                ? () => setState(() => selectedIndex = i)
                : null,
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                color: value == null
                    ? (isSelected
                        ? Colors.orange
                        : Colors.orange.shade200)
                    : Colors.orange,
                child: Text(
                  value?.toString() ?? "....",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNumberPad() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      children: List.generate(9, (i) {
        final number = i + 1;
        return GestureDetector(
          onTap: () => _inputNumber(number),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$number",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(w * 0.25, 0)
      ..lineTo(w * 0.75, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(w * 0.75, h)
      ..lineTo(w * 0.25, h)
      ..lineTo(0, h * 0.5)
      ..close();
  }

  @override
  bool shouldReclip(_) => false;
}
