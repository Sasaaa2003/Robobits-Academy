import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'level1_result_dialog.dart';
import 'package:robobits/level_mudah_page.dart';
import 'package:robobits/audio/level1_bgm.dart';

class Level1GamePage extends StatefulWidget {
  final String username;

  const Level1GamePage({
    super.key,
    required this.username,
  });

  @override
  State<Level1GamePage> createState() => _Level1GamePageState();
}

class _Level1GamePageState extends State<Level1GamePage> {
  int lampCount = 0;
  bool isPaused = false;
  bool _showCemas = false;

  final AudioPlayer _sfxPlayer = AudioPlayer();

  String get _robotAsset =>
      _showCemas ? "assets/cemas.png" : "assets/robot.png";

  final List<_GameItem> items = [
    _GameItem("assets/monitor.png", true),
    _GameItem("assets/tablet.png", false),
    _GameItem("assets/tv.png", false),
    _GameItem("assets/tv.png", false),
    _GameItem("assets/monitor.png", true),
    _GameItem("assets/tablet.png", false),
    _GameItem("assets/monitor.png", true),
    _GameItem("assets/tv.png", false),
  ];

  void _showBubble() {
    setState(() => _showCemas = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _showCemas = false);
    });
  }

  Future<void> _onItemTap(_GameItem item) async {
  if (isPaused || item.isAnswered) return;

  if (item.isCorrect) {
    await _playCorrectSound(); // ✅ SOUND BENAR

    setState(() {
      item.isAnswered = true;
      lampCount++;
    });

    if (lampCount == 3) {
      await Level1Bgm.stop(); // ⛔ STOP BGM LEVEL

      Future.delayed(const Duration(milliseconds: 400), () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Level1ResultDialog(
  score: 300,
  username: widget.username,
),

        );
      });
    }
  } else {
    await _playWrongSound(); // ❌ SOUND SALAH
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
            "Coba lagi ya!",
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
          Image.asset(
            "assets/bg_compile.jpg",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
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
                                  "RoboBits harus memilih mana yang benar agar data bisa dibaca.\n"
                                  "Temukan monitor di antara gambar-gambar ini!",
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

                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(12),
                            physics: const BouncingScrollPhysics(),
                            itemCount: items.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1.3,
                            ),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return GestureDetector(
                                onTap: () => _onItemTap(item),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: item.isAnswered
                                        ? Colors.green.withOpacity(0.3)
                                        : Colors.white.withOpacity(0.9),
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      item.asset,
                                      height: 90,
                                    ),
                                  ),
                                ),
                              );
                            },
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

          // 🔙 BACK BUTTON
          Positioned(
            left: 24,
            bottom: 24,
            child: GestureDetector(
              onTap: () async {
                await _sfxPlayer.play(
                  AssetSource('Audios/click.wav'),
                );

                await Level1Bgm.stop(); // ⛔ STOP MUSIC

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

class _GameItem {
  final String asset;
  final bool isCorrect;
  bool isAnswered = false;

  _GameItem(this.asset, this.isCorrect);
}
