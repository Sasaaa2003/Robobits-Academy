import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home_page.dart';
import 'settings_page.dart';


class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage>
    with TickerProviderStateMixin {
  int _navIndex = 0;
  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, dynamic>> ranks = [
    {"name": "Albert03", "score": 980},
    {"name": "Nabila", "score": 920},
    {"name": "Rizky", "score": 880},
    {"name": "Dinda", "score": 820},
    {"name": "Putra", "score": 780},
    {"name": "Alya", "score": 740},
  ];

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // ===== BACKGROUND =====
          Image.asset(
            "assets/bg2.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withOpacity(0.25),
        Colors.black.withOpacity(0.55),
      ],
    ),
  ),
),


          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),

               Text(
  "TOP PLAYERS",
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    letterSpacing: 3,
    color: Colors.white,
    shadows: [
      Shadow(
        offset: Offset(2, 2),
        color: Colors.blueAccent.withOpacity(0.8),
        blurRadius: 12,
      ),
    ],
  ),
),

                const SizedBox(height: 20),

                _mainCard(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _navbar(context),
    );
  }

  // ================= MAIN CARD =================
  Widget _mainCard() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Container(
          padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFB8C1D9),
      Color(0xFF8E97B8),
    ],
  ),
  borderRadius: BorderRadius.circular(28),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 18,
      offset: const Offset(0, 10),
    ),
  ],
),

          child: Column(
            children: [
              _podium(),
              const SizedBox(height: 20),
              Expanded(child: _rankList()),
            ],
          ),
        ),
      ),
    );
  }

  // ================= PODIUM =================
  Widget _podium() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ===== BACKGROUND IMAGE (NGIKUT UKURAN BOX ASLI) =====
          Positioned.fill(
            child: Image.asset(
              "assets/bg_podium.jpg",
              fit: BoxFit.cover, // image menyesuaikan box
            ),
          ),

          // ===== OVERLAY =====
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.45),
                  ],
                ),
              ),
            ),
          ),

          // ===== PODIUM CONTENT (ASLI, TIDAK DIUBAH) =====
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _podiumItem(2, ranks[1], height: 100),
              _podiumItem(1, ranks[0], height: 140, isFirst: true),
              _podiumItem(3, ranks[2], height: 80),
            ],
          ),
        ],
      ),
    ),
  );
}

 Widget _podiumItem(
  int rank,
  Map<String, dynamic> data, {
  required double height,
  bool isFirst = false,
}) {
  // Warna podium berdasarkan rank
  List<Color> podiumColors;
  Color textColor;

  if (rank == 1) {
    podiumColors = const [
      Color(0xFFFFE082),
      Color(0xFFFFB300),
    ];
    textColor = Colors.brown;
  } else if (rank == 2) {
    podiumColors = const [
      Color(0xFFE0E0E0),
      Color(0xFF9E9E9E),
    ];
    textColor = Colors.black87;
  } else {
    podiumColors = const [
      Color(0xFFD7A86E),
      Color(0xFF8D5A2B),
    ];
    textColor = Colors.white;
  }

  return Column(
    children: [
      SizedBox(
        width: isFirst ? 60 : 48,
        height: isFirst ? 60 : 48,
        child: Image.asset(
          "assets/rank_$rank.png",
          fit: BoxFit.contain,
        ),
      ),

      const SizedBox(height: 6),

      Text(
        data["name"],
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 6,
            ),
          ],
        ),
      ),

      const SizedBox(height: 6),

      Container(
        width: 80,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: podiumColors,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: rank == 1 ? 14 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          data["score"].toString(),
          style: TextStyle(
            fontSize: rank == 1 ? 18 : 16,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
      ),
    ],
  );
}



  // ================= RANK LIST =================
  Widget _rankList() {
    return ListView.separated(
      itemCount: ranks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final data = ranks[index];
        return Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
  gradient: const LinearGradient(
    colors: [
      Color(0xFFF5F7FA),
      Color(0xFFE4E7ED),
    ],
  ),
  borderRadius: BorderRadius.circular(20),
  border: Border.all(
    color: const Color(0xFF3B8DDF),
    width: 4,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 10,
      offset: const Offset(0, 6),
    ),
  ],
),

          child: Row(
            children: [
              CircleAvatar(
  radius: 18,
  backgroundColor: const Color(0xFF3B8DDF),
  child: Text(
    "${index + 1}",
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  ),
),

              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  data["name"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                data["score"].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= NAVBAR (SAMA DENGAN SETTINGS) =================
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

        if (index == 2) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const SettingsPage(),
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
}
