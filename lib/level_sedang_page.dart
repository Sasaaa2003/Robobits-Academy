import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';


// ===== LEVEL SEDANG INTRO =====
import 'levelsedang/level1/level1_intro_page.dart';
import 'levelsedang/level2/level2_intro_page.dart';
import 'levelsedang/level3/level3_intro_page.dart';



class LevelSedangPage extends StatefulWidget {
  const LevelSedangPage({super.key});

  @override
  State<LevelSedangPage> createState() => _LevelSedangPageState();
}

class _LevelSedangPageState extends State<LevelSedangPage>
    with SingleTickerProviderStateMixin {
  late AnimationController floatController;
  late Animation<double> floatAnimation;

  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // ===== FLOAT ANIMATION =====
    floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    floatAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: floatController, curve: Curves.easeInOut),
    );

    // ===== BGM =====
    _bgPlayer.setReleaseMode(ReleaseMode.loop);
    _bgPlayer.play(
      AssetSource('Audios/bgsound.mp3'),
      volume: 0.5,
    );
  }

  @override
  void dispose() {
    floatController.dispose();
    _bgPlayer.stop();
    _bgPlayer.dispose();
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
            "assets/bg2.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ===== TITLE =====
                  const Text(
                    "Level Challenge",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== STORY =====
                  SizedBox(
                    height: 140,
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                "Robobits tiba di Pulau Network.\n"
                                "Ayo bantu Robobits menyelesaikan semua tantangan\n"
                                "dan mendapatkan lampu energi!",
                                textStyle: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                                speed:
                                    const Duration(milliseconds: 80),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        AnimatedBuilder(
                          animation: floatAnimation,
                          builder: (_, child) {
                            return Transform.translate(
                              offset: Offset(0, -floatAnimation.value),
                              child: child,
                            );
                          },
                          child: Image.asset(
                            "assets/Robo2.png",
                            height: 110,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== GRID LEVEL =====
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GridView.builder(
                        itemCount: 9,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.72,
                        ),
                        itemBuilder: (context, index) {
                          final unlocked = index < 3;

                          return GestureDetector(
                            onTap: unlocked
                                ? () async {
                                    await _sfxPlayer.play(
                                      AssetSource(
                                          'Audios/click.wav'),
                                    );

                                    _bgPlayer.stop();

                                    // ===== ROUTING LEVEL =====
                                    if (index == 0) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SedangLevel1IntroPage(),
    ),
  );
} else if (index == 1) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SedangLevel2IntroPage(),
    ),
  );
} else if (index == 2) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const SedangLevel3SedangIntroPage(),
    ),
  );
}

                                  }
                                : null,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    // ===== ICON =====
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/levelcircle2.png",
                                          width: constraints.maxWidth * 0.75,
                                        ),
                                        unlocked
                                            ? Text(
                                                "${index + 1}",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      221, 9, 71, 2),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.lock,
                                                size: 22,
                                                color:
                                                    Colors.black45,
                                              ),
                                      ],
                                    ),

                                    const SizedBox(height: 4),

                                    // ===== LABEL =====
                                    if (unlocked)
                                      Text(
                                        index == 0
                                            ? "Logika"
                                            : index == 1
                                                ? "Matematika"
                                                : "Algoritma",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),

                                    const SizedBox(height: 4),

                                    // ===== LAMP =====
                                    if (unlocked)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          3,
                                          (_) => Image.asset(
                                            "assets/lamp.png",
                                            width: 22,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== BACK BUTTON =====
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () async {
                        await _sfxPlayer.play(
                          AssetSource('Audios/click.wav'),
                        );
                        _bgPlayer.stop();
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "assets/btn back.png",
                        width: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
