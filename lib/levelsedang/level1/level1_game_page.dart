import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:robobits/level_sedang_page.dart';
import 'package:robobits/levelsedang/level1/level1_result_dialog.dart';
import 'package:robobits/audio/level1_bgm.dart';

class SedangLevel1GamePage extends StatefulWidget {
  final String username;
  const SedangLevel1GamePage({super.key, required this.username});

  @override
  State<SedangLevel1GamePage> createState() => _SedangLevel1GamePageState();
}

class _SedangLevel1GamePageState extends State<SedangLevel1GamePage> {
  final Set<String> selectedShapes = {};
  final AudioPlayer _sfxPlayer = AudioPlayer();

  int lampCount = 0;
  bool isPaused = false;
  bool _showCemas = false;

  late List<String> shapeOptions;

  @override
  void initState() {
    super.initState();

    shapeOptions = [
      "segitiga",
      "persegi",
      "persegi_panjang", // ✅ BENAR
      "bintang",
      "lingkaran",
      "oval",
      "diamond",
      "hexagon",
      "love",
    ];

    shapeOptions.shuffle(Random());
  }

  String get _robotAsset =>
      _showCemas ? "assets/cemas.png" : "assets/robot.png";

  // ================= ROBOT CEMAS =================
  void _showBubble() {
    setState(() => _showCemas = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _showCemas = false);
    });
  }

  // ================= PILIH BENTUK =================
  void _selectShape(String type) async {
    if (isPaused || selectedShapes.contains(type)) return;

    setState(() => selectedShapes.add(type));

    if (selectedShapes.length == 3) {
      _checkAnswer();
    }
  }

  // ================= CEK JAWABAN =================
  Future<void> _checkAnswer() async {
    isPaused = true;

    const correct = {
      "segitiga",
      "persegi",
      "persegi_panjang",
    };

    if (selectedShapes.containsAll(correct)) {
      await _sfxPlayer.play(AssetSource('Audios/correct.mp3'));
      setState(() => lampCount = 3);
      await Level1Bgm.stop();

      Future.delayed(const Duration(milliseconds: 400), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => SedangLevel1ResultDialog(score: 300, username: widget.username),
        );
      });
    } else {
      await _sfxPlayer.play(AssetSource('Audios/wrong.mp3'));
      _showBubble();
      setState(() {
        selectedShapes.clear();
        isPaused = false;
      });
    }
  }

  // ================= LAMP =================
  Widget _lamp(bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Opacity(
        opacity: active ? 1 : 0.3,
        child: Image.asset("assets/lamp.png", width: 18),
      ),
    );
  }

  // ================= BUBBLE =================
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
              BoxShadow(color: Colors.black26, blurRadius: 6),
            ],
          ),
          child: const Text(
            "Coba perhatikan lagi ya!",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // ================= SHAPE BUILDER =================
  Widget buildShape(String type) {
    switch (type) {
      case "segitiga":
        return CustomPaint(
          size: const Size(50, 40),
          painter: TrianglePainter(Colors.green),
        );
      case "persegi":
        return Container(width: 45, height: 45, color: Colors.orange);
      case "persegi_panjang":
        return Container(width: 28, height: 45, color: Colors.red);
      case "bintang":
        return const Icon(Icons.star, size: 40, color: Colors.purple);
      case "lingkaran":
        return Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        );
      case "oval":
        return Container(
          width: 45,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      case "diamond":
        return Transform.rotate(
          angle: 0.785,
          child: Container(width: 35, height: 35, color: Colors.indigo),
        );
      case "hexagon":
        return const Icon(Icons.hexagon, size: 40, color: Colors.brown);
      case "love":
  return CustomPaint(
    size: const Size(40, 36),
    painter: HeartPainter(Colors.pink),
  );

      default:
        return const SizedBox();
    }
  }

  Widget shapeButton(String type) {
    final selected = selectedShapes.contains(type);

    return GestureDetector(
      onTap: () => _selectShape(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected
              ? Colors.green.shade200
              : const Color(0xFF4C79C5),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6),
          ],
        ),
        child: Center(child: buildShape(type)),
      ),
    );
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

                        // ===== ROBOT =====
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              AnimatedSwitcher(
                                duration:
                                    const Duration(milliseconds: 300),
                                child: Image.asset(
                                  _robotAsset,
                                  key: ValueKey(_robotAsset),
                                  height: 75,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "RoboBits harus mengenali bentuk yang sesuai dengan pola yang diminta."
                                  "Pilih 3 bentuk\nuntuk membentuk rumah!",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== CONTOH RUMAH BESAR =====
                        Container(
                          padding: const EdgeInsets.fromLTRB(80, 16, 80, 16),
                          decoration: BoxDecoration(
                          
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              CustomPaint(
                                size: const Size(90, 65),
                                painter:
                                    TrianglePainter(Colors.green),
                              ),
                              Container(
                                width: 90,
                                height: 90,
                                color: Colors.orange,
                                alignment: Alignment.center,
                                child: Container(
                                  width: 35,
                                  height: 55,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ===== PILIHAN 9 BENTUK =====
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 3,
                            padding: const EdgeInsets.all(16),
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            children: shapeOptions
                                .map((e) => shapeButton(e))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    _bubbleToast(),
                  ],
                ),
              ),
            ),
          ),

          // ===== BACK BUTTON =====
          Positioned(
            left: 24,
            bottom: 24,
            child: GestureDetector(
              onTap: () async {
                await _sfxPlayer.play(AssetSource('Audios/click.wav'));
                await Level1Bgm.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LevelSedangPage(username: widget.username),
                  ),
                );
              },
              child: Image.asset("assets/btn back.png", width: 50),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= TRIANGLE PAINTER =================
class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeartPainter extends CustomPainter {
  final Color color;
  HeartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.cubicTo(
      size.width * 1.1, size.height * 0.6,
      size.width * 0.8, size.height * 0.05,
      size.width / 2, size.height * 0.3,
    );
    path.cubicTo(
      size.width * 0.2, size.height * 0.05,
      -size.width * 0.1, size.height * 0.6,
      size.width / 2, size.height,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

