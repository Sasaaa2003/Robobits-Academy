import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:robobits/audio/level1_bgm.dart';
import 'level3_result_dialog.dart';
import 'package:robobits/level_sulit_page.dart';

/* ================= KONSTANTA ================= */
const double nodeSize = 38;
const double minGap = 50;
const int totalArena = 4;

/* ================= PAGE ================= */
class SulitLevel3GamePage extends StatefulWidget {
  const SulitLevel3GamePage({super.key});

  @override
  State<SulitLevel3GamePage> createState() => _SulitLevel3GamePageState();
}

class _SulitLevel3GamePageState extends State<SulitLevel3GamePage> {
  final AudioPlayer _clickPlayer = AudioPlayer();

  bool _showCemas = false;

  final List<Color> order = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
  ];

  int finishedArena = 0;

  @override
  void initState() {
    super.initState();
    Level1Bgm.play();
  }

  void _showBubble() {
    setState(() => _showCemas = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showCemas = false);
    });
  }

  void _arenaFinished() {
    setState(() => finishedArena++);
    if (finishedArena == totalArena) {
      Level1Bgm.stop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const SulitLevel3ResultDialog(score: 800),
      );
    }
  }

  @override
  void dispose() {
    _clickPlayer.dispose();
    Level1Bgm.stop();
    super.dispose();
  }

  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/bg_chips.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 80),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildTopBar(),
                    const SizedBox(height: 16),
                    _buildRobotText(),
                    const SizedBox(height: 16),
                    _buildQuestionBoard(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        padding: const EdgeInsets.all(12),
                        children: List.generate(
                          totalArena,
                          (_) => LampArena(
                            order: order,
                            onWrong: _showBubble,
                            onFinish: _arenaFinished,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// BACK BUTTON
          Positioned(
            left: 24,
            bottom: 24,
            child: GestureDetector(
              onTap: () async {
                await _clickPlayer.play(
                  AssetSource('Audios/click.wav'),
                );
                Level1Bgm.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LevelSulitPage(),
                  ),
                );
              },
              child: Image.asset("assets/btn back.png", width: 50),
            ),
          ),
        ],
      ),
    );
  }

  /* ================= TOP BAR ================= */
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset("assets/refresh.png", width: 36),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF4C79C5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  /// LAMPU INDIKATOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      totalArena,
                      (i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Opacity(
                          opacity: i < finishedArena ? 1 : 0.3,
                          child: Image.asset(
                            "assets/lamp.png",
                            width: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  /// PROGRESS BAR
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: finishedArena / totalArena,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Image.asset("assets/jeda.png", width: 36),
        ],
      ),
    );
  }

  Widget _buildRobotText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset(
            _showCemas ? "assets/cemas.png" : "assets/robot.png",
            height: 75,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "lampu yang mengacaukan alur kerja."
              "\nRoboBits harus menyusunnya kembali agar lampu dapat menyala.",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionBoard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(order.length, (i) {
          return Column(
            children: [
              Icon(Icons.lightbulb, color: order[i], size: 32),
              Text("${i + 1}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          );
        }),
      ),
    );
  }
}

/* ================= ARENA ================= */
class LampArena extends StatefulWidget {
  final List<Color> order;
  final VoidCallback onFinish;
  final VoidCallback onWrong;

  const LampArena({
    super.key,
    required this.order,
    required this.onFinish,
    required this.onWrong,
  });

  @override
  State<LampArena> createState() => _LampArenaState();
}

class _LampArenaState extends State<LampArena> {
  final List<LampNode> nodes = [];
  final List<Offset> lines = [];
  Offset? current;
  int step = 0;
  bool done = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        if (nodes.isEmpty) _init(c.biggest);

        return GestureDetector(
          onPanStart: done ? null : _start,
          onPanUpdate: done ? null : _update,
          onPanEnd: done ? null : _end,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: done ? Colors.green : Colors.black12,
                width: 3,
              ),
            ),
            child: Stack(
              children: [
                /// GARIS (BELAKANG)
                Positioned.fill(
                  child: CustomPaint(
                    painter: LinePainter(lines, current),
                  ),
                ),

                /// LAMPU (DEPAN)
                for (var n in nodes)
                  Positioned(
                    left: n.pos.dx - nodeSize / 2,
                    top: n.pos.dy - nodeSize / 2,
                    child: Icon(
                      Icons.lightbulb,
                      size: nodeSize,
                      color: n.color,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _init(Size s) {
    final rand = Random();
    final shuffled = [...widget.order]..shuffle();

    for (final c in shuffled) {
      Offset pos;
      bool ok;
      do {
        pos = Offset(
          rand.nextDouble() * (s.width - nodeSize) + nodeSize / 2,
          rand.nextDouble() * (s.height - nodeSize) + nodeSize / 2,
        );
        ok = nodes.every((n) => (n.pos - pos).distance > minGap);
      } while (!ok);
      nodes.add(LampNode(c, pos));
    }
  }

  void _start(DragStartDetails d) {
    final startNode =
        nodes.firstWhere((n) => n.color == widget.order[0]);

    if ((startNode.pos - d.localPosition).distance <= nodeSize) {
      lines.clear();
      lines.add(startNode.pos);
      current = startNode.pos;
      step = 1;
      setState(() {});
    }
  }

  void _update(DragUpdateDetails d) {
    setState(() => current = d.localPosition);
  }

  void _end(DragEndDetails d) {
    final hitNode = nodes.firstWhere(
      (n) => (n.pos - current!).distance <= nodeSize,
      orElse: () => LampNode(Colors.transparent, Offset.zero),
    );

    if (hitNode.color == widget.order[step]) {
      lines.add(hitNode.pos);
      step++;

      if (step == widget.order.length) {
        done = true;
        current = null;
        widget.onFinish();
      }
    } else {
      lines.clear();
      step = 0;
      current = null;
      widget.onWrong();
    }
    setState(() {});
  }
}

/* ================= MODEL ================= */
class LampNode {
  final Color color;
  final Offset pos;
  LampNode(this.color, this.pos);
}

/* ================= PAINTER ================= */
class LinePainter extends CustomPainter {
  final List<Offset> points;
  final Offset? current;

  LinePainter(this.points, this.current);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    if (points.isNotEmpty && current != null) {
      canvas.drawLine(points.last, current!, paint);
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
