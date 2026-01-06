import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  int _navIndex = 2;
  final AudioPlayer _player = AudioPlayer();

  bool musicOn = true;
  bool soundOn = true;

  late AnimationController _saveController;
  late Animation<double> _saveScale;

  @override
  void initState() {
    super.initState();
    _saveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _saveScale = Tween(begin: 1.0, end: 0.95).animate(_saveController);
  }

  @override
  void dispose() {
    _saveController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // OVERLAY
          Container(color: Colors.black.withOpacity(0.35)),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9AA1B1),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _profile(),
                          const SizedBox(height: 24),

                          _menuItem(
                            image: "assets/music.png",
                            label: "Music",
                            value: musicOn,
                            onToggle: () {
                              setState(() => musicOn = !musicOn);
                            },
                          ),

                          const SizedBox(height: 30),

                          _menuItem(
                            image: "assets/sound.png",
                            label: "Sound",
                            value: soundOn,
                            onToggle: () {
                              setState(() => soundOn = !soundOn);
                            },
                          ),

                          const SizedBox(height: 30),

                          _menuItemSimple(
                            image: "assets/help.png",
                            label: "Help",
                          ),

                          const Spacer(),

                          // SAVE BUTTON
                          GestureDetector(
                            onTapDown: (_) => _saveController.forward(),
                            onTapUp: (_) {
                              _saveController.reverse();
                              Navigator.pop(context);
                            },
                            onTapCancel: () => _saveController.reverse(),
                            child: ScaleTransition(
                              scale: _saveScale,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 80),
                                height: 46,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4EB0E1),
                                      Color(0xFF3B8DDF),
                                      Color(0xFF2D76EA),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "SAVE",
                                  style: TextStyle(
                                    fontSize: 17,
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
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _navbar(context),
    );
  }

  // ================= NAVBAR =================
  Widget _navbar(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Center(
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navButton(index: 0, image: "assets/btn rank.png"),
              _navButton(index: 1, image: "assets/btn home.png"),
              _navButton(index: 2, image: "assets/btn settings.png"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton({required int index, required String image}) {
    final isActive = _navIndex == index;

    return GestureDetector(
      onTap: () async {
        try {
          await _player.stop();
          await _player.play(AssetSource('Audios/click.wav'));
        } catch (_) {}

        if (index == _navIndex) return;

        if (index == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const HomePage(username: "Albert03"),
            ),
            (route) => false,
          );
        }
      },
      child: SizedBox(
        width: 60,
        height: 90,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              top: isActive ? -10 : -8,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ]
                      : [],
                ),
                child: Image.asset(image, height: 36),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PROFILE =================
 // ================= PROFILE =================
Widget _profile() {
  return Row(
    children: [
      // AVATAR + CAMERA BUTTON
      Stack(
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white, size: 28),
          ),

          // CAMERA ICON NEMPEL DI AVATAR
          Positioned(
            bottom: -2,
            right: -2,
            child: GestureDetector(
              onTap: () {
                // TODO: buka kamera / galeri
              },
              child: Container(
                width: 20,
                height: 20,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/kamera.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),

      const SizedBox(width: 12),

      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Albert03",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(Icons.edit, size: 16),
            ],
          ),
        ),
      ),
    ],
  );
}


  // ================= MENU ITEM + TOGGLE =================
  Widget _menuItem({
    required String image,
    required String label,
    required bool value,
    required VoidCallback onToggle,
  }) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
         border: Border.all( color: const Color.fromARGB(255, 53, 87, 159) 
        , width: 5),
        color: const Color.fromARGB(255, 230, 231, 234),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Image.asset(image, width: 42, height: 42),
          const SizedBox(width: 18),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          _switchToggle(value: value, onTap: onToggle),
        ],
      ),
    );
  }

  // ================= MENU ITEM BIASA =================
  Widget _menuItemSimple({
    required String image,
    required String label,
  }) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all( color: const Color.fromARGB(255, 53, 87, 159) 
        , width: 5),
        color: const Color.fromARGB(255, 239, 239, 240),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Image.asset(image, width: 42, height: 42),
          const SizedBox(width: 18),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ================= TOGGLE X / ✓ (PERSIS OVERLAY) =================
  Widget _switchToggle({
    required bool value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFF5A86D8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.close,
                  size: 14, color: Colors.white.withOpacity(0.6)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.check,
                  size: 14, color: Colors.white.withOpacity(0.6)),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment:
                  value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
                child: Icon(
                  value ? Icons.check : Icons.close,
                  size: 14,
                  color: value ? Colors.green : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
