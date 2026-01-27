import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'rank_page.dart';

class SettingsPage extends StatefulWidget {
  final String username;
  const SettingsPage({super.key, required this.username});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  int _navIndex = 2;
  final AudioPlayer _player = AudioPlayer();

  final _user = FirebaseAuth.instance.currentUser!;
  final _db = FirebaseFirestore.instance;

  late TextEditingController _nameController;

  bool musicOn = true;
  bool soundOn = true;

  late AnimationController _saveController;
  late Animation<double> _saveScale;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.username);

    _saveController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _saveScale = Tween(begin: 1.0, end: 0.95).animate(_saveController);

    _load();
  }

  Future<void> _load() async {
    final snap = await _db.collection("users").doc(_user.uid).get();
    if (snap.exists) {
      setState(() {
        _nameController.text = snap["username"] ?? widget.username;
        musicOn = snap["music"] ?? true;
        soundOn = snap["sound"] ?? true;
      });
    }
  }

  Future<void> _save() async {
    if (soundOn) {
      await _player.stop();
      await _player.play(AssetSource('Audios/click.wav'));
    }

    await _db.collection("users").doc(_user.uid).set({
      "username": _nameController.text.trim(),
      "music": musicOn,
      "sound": soundOn,
    }, SetOptions(merge: true));

     _showSavedPopup();
  }
  void _showSavedPopup() {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "",
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Center(
          child: Container(
            width: 240,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromARGB(255, 255, 255, 255),
                width: 5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("SAVED!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                const Text("Pengaturan berhasil disimpan",
                    textAlign: TextAlign.center),
                const SizedBox(height: 14),
                _popupButton("OK", () => Navigator.pop(context)),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  void _showEditPopup() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.5),
          body: Center(
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 252, 252, 252),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: 5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("EDIT USERNAME",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 127, 169, 231),
                        borderRadius: BorderRadius.circular(14)),
                    child: TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _popupButton("CANCEL", () => Navigator.pop(context))),
                      const SizedBox(width: 10),
                      Expanded(child: _popupButton("OK", () => Navigator.pop(context))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _popupButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4EB0E1), Color(0xFF3B8DDF), Color(0xFF2D76EA)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  @override
  void dispose() {
    _saveController.dispose();
    _player.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // ================= NAV BUTTON (SAMA HOMEPAGE) =================
  Widget _navButton({required int index, required String image}) {
    final bool isActive = _navIndex == index;

    return GestureDetector(
      onTap: () async {
        try {
          await _player.stop();
          if (soundOn) {
            await _player.play(AssetSource('Audios/click.wav'));
          }
        } catch (_) {}

        if (index == _navIndex) return;

        setState(() => _navIndex = index);

        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => RankPage(username: _nameController.text),
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(username: _nameController.text),
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Image.asset("assets/bg2.png",
              width: double.infinity, height: double.infinity, fit: BoxFit.cover),
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
                        children: [
                          _profile(),
                          const SizedBox(height: 24),
                          _menuItem(
                            image: "assets/music.png",
                            label: "Music",
                            value: musicOn,
                            onToggle: () => setState(() => musicOn = !musicOn),
                          ),
                          const SizedBox(height: 30),
                          _menuItem(
                            image: "assets/sound.png",
                            label: "Sound",
                            value: soundOn,
                            onToggle: () => setState(() => soundOn = !soundOn),
                          ),
                          const SizedBox(height: 30),
                          _menuItemSimple(
                            image: "assets/help.png",
                            label: "Help",
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTapDown: (_) => _saveController.forward(),
                            onTapUp: (_) {
                              _saveController.reverse();
                              _save();
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
                                ),
                                child: const Text("SAVE",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
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

      // ===== NAVBAR =====
      bottomNavigationBar: SizedBox(
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
      ),
    );
  }

  Widget _profile() {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            const CircleAvatar(radius: 26, child: Icon(Icons.person)),
            Positioned(
              bottom: -2,
              right: -2,
              child: Image.asset("assets/kamera.png", width: 20),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: _showEditPopup,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_nameController.text,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Icon(Icons.edit, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _menuItem({
    required String image,
    required String label,
    required bool value,
    required VoidCallback onToggle,
  }) =>
      Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF35579F), width: 5),
          color: const Color(0xFFE6E7EA),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Image.asset(image, width: 42),
            const SizedBox(width: 18),
            Text(label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            _switchToggle(value: value, onTap: onToggle),
          ],
        ),
      );

  Widget _menuItemSimple({
    required String image,
    required String label,
  }) =>
      Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF35579F), width: 5),
          color: const Color(0xFFEFEFF0),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Image.asset(image, width: 42),
            const SizedBox(width: 18),
            Text(label,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _switchToggle({required bool value, required VoidCallback onTap}) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 32,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? const Color.fromARGB(255, 76, 116, 175) : const Color.fromARGB(255, 52, 135, 212),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment:
                  value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Text(
                value ? "ON" : "OFF",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );

}
