import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:robobits/audio/level1_bgm.dart';
import 'package:robobits/level_mudah_page.dart';
import 'level3_result_dialog.dart';

class Level3GamePage extends StatefulWidget {
  final String username;

  const Level3GamePage({
    super.key,
    required this.username,
  });

  @override
  State<Level3GamePage> createState() => _Level3GamePageState();
}

class _Level3GamePageState extends State<Level3GamePage> {
  final AudioPlayer _sfxPlayer = AudioPlayer();

  // ===== LAMP =====
  int lampCount = 0; // MULAI DARI MATI SEMUA

  // posisi robot (kiri bawah)
  int robotRow = 2;
  int robotCol = 0;

  // posisi bengkel (kanan atas)
  final int targetRow = 0;
  final int targetCol = 2;

  @override
  void initState() {
    super.initState();
    Level1Bgm.play();
  }

  void _moveRobot(int dRow, int dCol) async {
    final newRow = robotRow + dRow;
    final newCol = robotCol + dCol;

    if (newRow < 0 || newRow > 2 || newCol < 0 || newCol > 2) return;

    // lampu mulai nyala saat gerakan pertama
    if (lampCount == 0) {
      setState(() => lampCount = 1);
    }

    setState(() {
      robotRow = newRow;
      robotCol = newCol;
    });

    await _sfxPlayer.play(AssetSource('Audios/click.wav'));

    if (robotRow == targetRow && robotCol == targetCol) {
      setState(() => lampCount = 3);
      await Level1Bgm.stop();

      Future.delayed(const Duration(milliseconds: 400), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Level3ResultDialog(score: 300, username: widget.username),
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

  Widget _gridCell(int row, int col) {
    if (row == robotRow && col == robotCol) {
      return Image.asset(
        "assets/robot.png",
        height: 46,
        fit: BoxFit.contain,
      );
    }
    if (row == targetRow && col == targetCol) {
      return Image.asset(
        "assets/bengkel.png",
        height: 46,
        fit: BoxFit.contain,
      );
    }
    return const SizedBox();
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: 64,
        height: 64,
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
        child: Icon(icon, color: Colors.white, size: 36),
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
                child: SingleChildScrollView(
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

                      const SizedBox(height: 16),

                      // ===== ROBOT + INSTRUKSI =====
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/robot.png",
                              width: 80,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Robobits tersesat!\n"
                                "Bantu robot menemukan jalan\n"
                                "menuju bengkel dengan mengikuti\n"
                                "arah panah.",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ===== GRID =====
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: List.generate(3, (row) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (col) {
                                return Container(
                                  margin: const EdgeInsets.all(6),
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(14),
                                    border:
                                        Border.all(color: Colors.black26),
                                  ),
                                  child: Center(
                                    child: _gridCell(row, col),
                                  ),
                                );
                              }),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ===== CONTROLLER =====
                      Column(
                        children: [
                          _arrowButton(
                              Icons.keyboard_arrow_up,
                              () => _moveRobot(-1, 0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _arrowButton(
                                  Icons.keyboard_arrow_left,
                                  () => _moveRobot(0, -1)),
                              const SizedBox(width: 12),
                              _arrowButton(
                                  Icons.keyboard_arrow_right,
                                  () => _moveRobot(0, 1)),
                            ],
                          ),
                          _arrowButton(
                              Icons.keyboard_arrow_down,
                              () => _moveRobot(1, 0)),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
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
                await _sfxPlayer.play(
                  AssetSource('Audios/click.wav'),
                );
                await Level1Bgm.stop();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LevelMudahPage(username: widget.username),
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
