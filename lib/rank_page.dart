import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'settings_page.dart';

class RankPage extends StatefulWidget {
  final String username;
  const RankPage({super.key, required this.username});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  final AudioPlayer _player = AudioPlayer();
  final _user = FirebaseAuth.instance.currentUser!;
  final _db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> ranks = [];
  bool _loading = true;

  bool soundOn = true;
  bool musicOn = true;
  late String username;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    _loadSettings();
    _loadRanks();
  }

  // ================= LOAD SETTINGS =================
  Future<void> _loadSettings() async {
    final snap = await _db.collection("users").doc(_user.uid).get();
    if (snap.exists) {
      setState(() {
        soundOn = snap.data()?["sound"] ?? true;
        musicOn = snap.data()?["music"] ?? true;
        username = snap.data()?["username"] ?? username;
      });
    }
  }

  // ================= LOAD RANK =================
  Future<void> _loadRanks() async {
    final snapshot = await _db
        .collection('users')
        .orderBy('levelScore.totalScore', descending: true)
        .limit(20)
        .get();

    setState(() {
      ranks = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "uid": doc.id,
          "name": data["username"] ?? "Player",
          "score": data["levelScore"]?["totalScore"] ?? 0,
        };
      }).toList();

      _loading = false;
    });
  }

  // ================= PLAY CLICK =================
  Future<void> _playClick() async {
    if (!soundOn) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('Audios/click.wav'));
    } catch (_) {}
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myUid = _user.uid;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
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
                const Text(
                  "TOP PLAYERS",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB8C1D9), Color(0xFF8E97B8)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: _loading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: [
                                if (ranks.length >= 3) _podium(),
                                const SizedBox(height: 20),
                                Expanded(child: _rankList(myUid)),
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

      // ================= NAVBAR =================
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
                _navButton(0, "assets/btn rank.png"),
                _navButton(1, "assets/btn home.png"),
                _navButton(2, "assets/btn settings.png"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= NAV BUTTON =================
  Widget _navButton(int index, String image) {
    return GestureDetector(
      onTap: () async {
        await _playClick();

        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(username: username),
            ),
          );
        } else if (index == 2) {
          final newName = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SettingsPage(username: username),
            ),
          );

          if (newName != null) {
            setState(() => username = newName);
            _loadRanks();
          }
        }
      },
      child: Image.asset(image, height: 36),
    );
  }

  // ================= PODIUM =================
  Widget _podium() {
    final first = ranks[0];
    final second = ranks[1];
    final third = ranks[2];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _podiumItem(2, second, height: 100),
        _podiumItem(1, first, height: 140, isFirst: true),
        _podiumItem(3, third, height: 80),
      ],
    );
  }

  Widget _podiumItem(
    int rank,
    Map<String, dynamic> data, {
    required double height,
    bool isFirst = false,
  }) {
    return Column(
      children: [
        SizedBox(
          width: isFirst ? 60 : 48,
          height: isFirst ? 60 : 48,
          child: Image.asset("assets/rank_$rank.png"),
        ),
        const SizedBox(height: 6),
        Text(
          data["name"],
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          width: 80,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: rank == 1
                  ? const [Color(0xFFFFE082), Color(0xFFFFB300)]
                  : rank == 2
                      ? const [Color(0xFFE0E0E0), Color(0xFF9E9E9E)]
                      : const [Color(0xFFD7A86E), Color(0xFF8D5A2B)],
            ),
          ),
          child: Text(
            data["score"].toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  // ================= LIST =================
  Widget _rankList(String myUid) {
    return ListView.separated(
      itemCount: ranks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final data = ranks[index];
        final isMe = data["uid"] == myUid;

        return Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: isMe ? Colors.yellow.shade200 : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue,
                child: Text("${index + 1}"),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  data["name"],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                data["score"].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
