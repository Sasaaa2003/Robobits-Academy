import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'settings_page.dart';
import 'package:robobits/rank_page.dart';

import 'level_mudah_page.dart';
import 'level_sedang_page.dart';
import 'level_sulit_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  int _navIndex = 1;
  final AudioPlayer _player = AudioPlayer();

  final PageController _bannerController =
      PageController(viewportFraction: 0.85);

  int _currentBanner = 2;
  String _selectedCategory = "Semua";

  final List<String> banners = [
    "assets/banner.jpg",
    "assets/banner2.png",
    "assets/banner3.jpg",
  ];

  final List<String> bannerTexts = [
    "Robobits\nBelajar Teknologi Jadi Lebih Seru",
    "Asah Logika\nLewat Tantangan Interaktif",
    "Main & Belajar\nJadi Jago Informatika",
  ];

  final List<Map<String, dynamic>> levels = const [
    {
      'name': 'Lembah Compile',
      'image': 'assets/Robo1.png',
      'bg': 'assets/bglevel1.png',
      'difficulty': 'Mudah',
    },
    {
      'name': 'Pulau Network',
      'image': 'assets/Robo2.png',
      'bg': 'assets/bglevel2.png',
      'point': 2700,
      'difficulty': 'Sedang',
    },
    {
      'name': 'Kota Chips',
      'image': 'assets/Robo3.png',
      'bg': 'assets/bglevel3.png',
      'point': 4500,
      'difficulty': 'Sulit',
    },
  ];

  final _user = FirebaseAuth.instance.currentUser!;
final _db = FirebaseFirestore.instance;

late String username;
bool musicOn = true;
bool soundOn = true;


  List<Map<String, dynamic>> get filteredLevels {
    if (_selectedCategory == "Semua") return levels;
    return levels
        .where((e) => e['difficulty'] == _selectedCategory)
        .toList();
  }

  // ===== CARD ANIMATION (AMAN ANDROID + WEB) =====
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _floatAnimations = [];
  final List<bool> _isHovered = [];

  void _initHoverIfNeeded(int count) {
    if (_controllers.length == count) return;

    _disposeHover();

    for (int i = 0; i < count; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      ); // <<< IDLE ANIMATION

      _controllers.add(controller);
      _floatAnimations.add(
        Tween<double>(begin: 0, end: -8).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInOut),
        ),
      );
      _isHovered.add(false);
    }
  }
  Color _levelColor(String difficulty) {
  switch (difficulty) {
    case "Mudah":
      return const Color.fromARGB(255, 38, 40, 137);
    case "Sedang":
      return const Color.fromARGB(255, 26, 128, 24);
    case "Sulit":
      return const Color.fromARGB(255, 233, 112, 6);
    default:
      return Colors.white;
  }
}


  void _disposeHover() {
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers.clear();
    _floatAnimations.clear();
    _isHovered.clear();
  }
@override
void initState() {
  super.initState();
  username = widget.username;
  _loadSettings();
}

Future<void> _loadSettings() async {
  final snap = await _db.collection("users").doc(_user.uid).get();
  if (snap.exists) {
    setState(() {
      musicOn = snap["music"] ?? true;
      soundOn = snap["sound"] ?? true;
      username = snap["username"] ?? username;
    });
  }
}

  @override
  void dispose() {
    _disposeHover();
    _player.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  // ================= CATEGORY BUTTON =================
 Widget _categoryButton(String label, IconData icon) {
  final bool isActive = _selectedCategory == label;

    return GestureDetector(
  onTap: () async {
    // play sound klik
    try {
          await _player.stop();
          await _player.play(AssetSource('Audios/click.wav'));
        } catch (_) {}

    setState(() {
      _selectedCategory = label;
      _disposeHover();
    });
  },
    child: AnimatedScale(
      scale: isActive ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 200),

      // 🔑 HANYA SATU child
      child: SizedBox(
        width: 180,
        height: 50,
        // KUNCI JARAK ANTAR BUTTON
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isActive
                    ? const Color.fromARGB(255, 241, 242, 243)
                    : const Color.fromARGB(255, 255, 251, 251),
                borderRadius: BorderRadius.circular(12),
                
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: isActive ? const Color.fromARGB(255, 36, 37, 37) : const Color.fromARGB(255, 148, 146, 146),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      
                      color: isActive ? const Color.fromARGB(255, 36, 37, 37) : const Color.fromARGB(255, 133, 132, 132),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



  // ================= NAV BUTTON =================
  Widget _navButton({required int index, required String image}) {
    final bool isActive = _navIndex == index;

    return GestureDetector(
      onTap: () async {
        try {
          await _player.stop();
          if (soundOn) {
  await _player.stop();
  await _player.play(AssetSource('Audios/click.wav'));
}

        } catch (_) {}
        setState(() => _navIndex = index);
        if (index == 0) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => RankPage(username: widget.username),
    ),
  );
} 

else if (index == 1) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => HomePage(username: widget.username),
    ),
  );
}

else if (index == 2) {
  final newName = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => SettingsPage(username: username),
    ),
  );

  if (newName != null) {
    setState(() => username = newName);
  }
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
    _initHoverIfNeeded(filteredLevels.length);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Image.asset("assets/bg2.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== HEADER =====
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child:
                            Icon(Icons.person, color: Colors.black, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hallo, ${widget.username}!",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          const Text("Selamat datang di Robobits Academy",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ===== BANNER (TIDAK DIUBAH) =====
                  SizedBox(
                    height: 160,
                    child: PageView.builder(
                      controller: _bannerController,
                      itemCount: banners.length,
                      onPageChanged: (i) =>
                          setState(() => _currentBanner = i),
                      itemBuilder: (_, index) {
                        final isActive = index == _currentBanner;
                        return AnimatedScale(
                          scale: isActive ? 1.0 : 0.92,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              image: DecorationImage(
                                image: AssetImage(banners[index]),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(bannerTexts[index],
                                    style: const TextStyle(
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ===== DOT =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      banners.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentBanner == i ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentBanner == i
                              ? Colors.white
                              : Colors.white38,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===== CONTENT =====
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          // CATEGORY (AMAN OVERFLOW)
                         Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _categoryButton("Semua", Icons.apps), 
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: _categoryButton("Mudah", Icons.looks_one),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _categoryButton("Sedang", Icons.looks_two),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: _categoryButton("Sulit", Icons.looks_3),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                          const SizedBox(height: 20),

                          const Text("Pilih Petualanganmu",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),

                          const SizedBox(height: 16),

                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredLevels.length,
                              itemBuilder: (_, i) {
                                final item = filteredLevels[i];
                                return MouseRegion(
                                   onEnter: (_) {
                                    setState(() => _isHovered[i] = true);
                                    _controllers[i].repeat(reverse: true); // MELAYANG SAAT HOVER
                                  },
                                  onExit: (_) {
                                    setState(() => _isHovered[i] = false);
                                    _controllers[i].stop();
                                    _controllers[i].reset(); // BALIK KE POSISI AWAL
                                  },
                                  child: GestureDetector(
                                    onTap: () async {
                                      try {
                                        await _player.stop();
                                        await _player.play(
                                            AssetSource('Audios/click.wav'));
                                      } catch (_) {}
                                      if (item['difficulty'] == "Mudah") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const LevelMudahPage()),
                                        );
                                      } if(item['difficulty'] == "Sedang") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const LevelSedangPage()),
                                        );
                                      } if (item['difficulty'] == "Sulit") {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const LevelSulitPage()),
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: 140,
                                      margin:
                                          const EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(24),
                                            image: DecorationImage(
      image: AssetImage(item['bg']),
      fit: BoxFit.cover,
    ),
                                            border: Border.all(
      color: _isHovered[i]
          ? Colors.white.withOpacity(0.70) // terang saat hover
          : Colors.white.withOpacity(0.70), // normal
      width: 1.9, ),
                                        gradient: _isHovered[i]
                                            ? const LinearGradient(colors: [
                                                Color.fromARGB(
                                                    255, 38, 74, 112),
                                                Color.fromARGB(
                                                    255, 28, 25, 58),
                                              ])
                                            : const LinearGradient(colors: [
                                                Color(0xFF5FA3FF),
                                                Color(0xFF6A5AE0),
                                              ]),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AnimatedBuilder(
                                            animation: _controllers[i],
                                            builder: (_, child) =>
                                                Transform.translate(
                                                    offset: Offset(
                                                        0,
                                                        _floatAnimations[i]
                                                            .value),
                                                    child: child),
                                            child: Image.asset(
                                                item['image'],
                                                height: 100),
                                          ),
                                          const SizedBox(height: 4),
                                        Stack(
  children: [
    // OUTLINE
    Text(
      item['name'],
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..color = const Color.fromARGB(255, 255, 255, 255),
      ),
    ),

    // TEKS UTAMA (WARNA BERDASARKAN LE
    // VEL)
    Text(
      item['name'],
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: _levelColor(item['difficulty']),
      ),
    ),
  ],
),


                                          Text(item['difficulty'],
                                              style: const TextStyle(
                                                  color: Color.fromARGB(179, 55, 54, 54))),
                                        ],
                                      ),
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
                ],
              ),
            ),
          ),
        ],
      ),

      // ===== NAVBAR (TIDAK DIUBAH) =====
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
}
