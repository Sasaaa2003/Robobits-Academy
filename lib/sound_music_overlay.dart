import 'package:flutter/material.dart';

class SoundMusicOverlay extends StatefulWidget {
  const SoundMusicOverlay({super.key});

  @override
  State<SoundMusicOverlay> createState() => _SoundMusicOverlayState();
}

class _SoundMusicOverlayState extends State<SoundMusicOverlay> {
  bool musicOn = true;
  bool soundOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ===== OVERLAY GELAP =====
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),

          // ===== PANEL TOGGLE =====
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _toggleCard(
                  title: "Music",
                  value: musicOn,
                  onTap: () => setState(() => musicOn = !musicOn),
                ),
                const SizedBox(height: 16),
                _toggleCard(
                  title: "Sound",
                  value: soundOn,
                  onTap: () => setState(() => soundOn = !soundOn),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== CARD =====
  Widget _toggleCard({
    required String title,
    required bool value,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          _switchToggle(value: value, onTap: onTap),
        ],
      ),
    );
  }

  // ===== TOGGLE X / ✓ =====
  Widget _switchToggle({
    required bool value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF5A86D8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.close,
                  color: Colors.white.withOpacity(0.7)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.check,
                  color: Colors.white.withOpacity(0.7)),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment:
                  value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 36,
                height: 36,
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
