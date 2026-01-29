import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home_page.dart';

// ===== LEVEL INTRO =====
import 'levelmudah/level1/level1_intro_page.dart';
import 'levelmudah/level2/level2_intro_page.dart';
import 'levelmudah/level3/level3_intro_page.dart';

class LevelMudahPage extends StatefulWidget {
  final String username;
  const LevelMudahPage({super.key, required this.username});


  @override
  State<LevelMudahPage> createState() => _LevelMudahPageState();
}

class _LevelMudahPageState extends State<LevelMudahPage>
    with SingleTickerProviderStateMixin {
  late AnimationController floatController;
  late Animation<double> floatAnimation;

  final AudioPlayer globalBgmPlayer = AudioPlayer();
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

    // ===== GLOBAL BGM =====
    globalBgmPlayer.setReleaseMode(ReleaseMode.loop);
    globalBgmPlayer.play(
      AssetSource('Audios/bgsound.mp3'),
      volume: 0.5,
    );
  }

  void stopBgm() {
    globalBgmPlayer.stop();
  }

  @override
  void dispose() {
    floatController.dispose();
    globalBgmPlayer.stop();
    globalBgmPlayer.dispose();
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
                                "Robobits tiba di Lembah Compile.\n"
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
                              offset:
                                  Offset(0, -floatAnimation.value),
                              child: child,
                            );
                          },
                          child: Image.asset(
                            "assets/Robo1.png",
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
                          final unlocked = index < 3; // level 1–3 terbuka

                          return GestureDetector(
                            onTap: () async {
  await _sfxPlayer.play(
    AssetSource('Audios/click.wav'),
  );

  if (!unlocked) {
    // ===== POPUP COMING SOON =====
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1F4B),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/Robot.png",
                height: 90,
              ),
              const SizedBox(height: 12),
              const Text(
                "COMING SOON!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Level ini masih terkunci.\n",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return;
  }

  // ===== LEVEL TERBUKA =====
  stopBgm();

  if (index == 0) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Level1IntroPage(username: widget.username),
      ),
    );
  } else if (index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Level2IntroPage(username: widget.username),
      ),
    );
  } else if (index == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Level3IntroPage(username: widget.username),
      ),
    );
  }
},

                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/levelcircle1.png",
                                      width: 70,
                                    ),
                                    unlocked
                                        ? Text(
                                            "${index + 1}",
                                            style:
                                                const TextStyle(
                                              fontSize: 20,
                                              fontWeight:
                                                  FontWeight.bold,
                                              color: Color.fromARGB(
                                                  221, 5, 19, 69),
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

                                if (unlocked)
                                  Text(
                                    index == 0
                                        ? "Logika"
                                        : index == 1
                                            ? "Matematika"
                                            : "Algoritma",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                const SizedBox(height: 4),

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
      await _sfxPlayer.play(AssetSource('Audios/click.wav'));
      stopBgm();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(username: widget.username),
        ),
        (route) => false,
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
            ),
          ),
        ],
      ),
    );
  }
}
