import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:robobits/level_mudah_page.dart';

class SedangLevel1ResultDialog extends StatefulWidget {
  final int score;
  const SedangLevel1ResultDialog({super.key, required this.score});

  @override
  State<SedangLevel1ResultDialog> createState() => _SedangLevel1ResultDialogState();
}

class _SedangLevel1ResultDialogState extends State<SedangLevel1ResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;

  final Random _rand = Random();

  final List<IconData> _particles = [
    Icons.star,
    Icons.auto_awesome,
    Icons.circle,
  ];

  @override
  void initState() {
    super.initState();

    // 🎬 PARTICLE ANIMATION
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // 🔊 AUDIO WINNER
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(
      AssetSource('Audios/winner.mp3'),
      volume: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.45),
      body: Stack(
        children: [
          // 🌟 PARTICLE EFFECT
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Stack(
                children: List.generate(18, (i) {
                  final double startX = _rand.nextDouble();
                  final double speed = 0.3 + _rand.nextDouble();
                  final double y =
                      (_controller.value * speed + _rand.nextDouble()) % 1;

                  return Positioned(
                    left: MediaQuery.of(context).size.width * startX,
                    top: MediaQuery.of(context).size.height * y,
                    child: Opacity(
                      opacity: 0.6,
                      child: Icon(
                        _particles[i % _particles.length],
                        size: 14.0 + _rand.nextInt(12).toDouble(),
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // 💙 DIALOG
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 320,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C6FBF),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Level\nComplete",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/lamp.png", width: 26),
                            const SizedBox(width: 10),
                            Image.asset("assets/lamp.png", width: 42),
                            const SizedBox(width: 10),
                            Image.asset("assets/lamp.png", width: 26),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          "Score",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${widget.score}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ▶ NEXT BUTTON
                        GestureDetector(
                          onTap: () {
                            _audioPlayer.stop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LevelMudahPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 46,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF4EB0E1),
                                  Color(0xFF3B8DDF),
                                  Color(0xFF2D76EA),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Center(
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ❌ CLOSE BUTTON
                Positioned(
                  top: -14,
                  right: -14,
                  child: GestureDetector(
                    onTap: () {
                      _audioPlayer.stop();
                      Navigator.pop(context);
                    },
                    child: Image.asset("assets/close.png", width: 60),
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
