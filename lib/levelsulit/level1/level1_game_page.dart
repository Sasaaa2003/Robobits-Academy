import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:robobits/audio/level1_bgm.dart';
import 'level1_result_dialog.dart';
import 'package:robobits/level_sulit_page.dart';

/* ================= KONSTANTA ================= */
const double socketSize = 44;
const int totalPairs = 6;
const double arenaPadding = 20;

/* ================= PAGE ================= */
class SulitLevel1GamePage extends StatefulWidget {
  final String username;
  const SulitLevel1GamePage({super.key, required this.username});

  @override
  State<SulitLevel1GamePage> createState() =>
      _SulitLevel1GamePageState();
}

class _SulitLevel1GamePageState
    extends State<SulitLevel1GamePage> {
  final AudioPlayer _clickPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  int lampCount = 0;
  bool _showCemas = false;

  Offset? dragStart;
  Offset? dragCurrent;
  ColorNode? startNode;

  final List<ColorNode> nodes = [];
  final List<Connection> connections = [];

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    Level1Bgm.play();
  }

  /* ================= INIT NODE ================= */
  void _initNodes(Size size) {
    const colors = [
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.orange,
    ];

    final rand = Random();
    nodes.clear();
    connections.clear();
    lampCount = 0;

    for (final c in colors) {
      nodes.add(ColorNode(c));
      nodes.add(ColorNode(c));
    }

    for (final node in nodes) {
      bool placed = false;
      while (!placed) {
        final pos = Offset(
          arenaPadding +
              rand.nextDouble() *
                  (size.width -
                      arenaPadding * 2),
          arenaPadding +
              rand.nextDouble() *
                  (size.height -
                      arenaPadding * 2),
        );

        bool overlap = false;
        for (final other in nodes) {
          if (other.position != Offset.zero &&
              (other.position - pos).distance <
                  socketSize + 8) {
            overlap = true;
            break;
          }
        }

        if (!overlap) {
          node.position = pos;
          placed = true;
        }
      }
    }

    _initialized = true;
  }

  /* ================= SOUND ================= */
  Future<void> _playCorrect() async {
    await _effectPlayer.stop();
    await _effectPlayer.play(
        AssetSource('Audios/correct.mp3'));
  }

  Future<void> _playWrong() async {
    await _effectPlayer.stop();
    await _effectPlayer.play(
        AssetSource('Audios/wrong.mp3'));
  }

  void _showBubble() {
    setState(() => _showCemas = true);
    Future.delayed(const Duration(milliseconds: 800),
        () {
      if (mounted) setState(() => _showCemas = false);
    });
  }

  void _checkFinish() async {
    if (connections.length == totalPairs) {
      await Level1Bgm.stop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            SulitLevel1ResultDialog(score: 500, username: widget.username),
      );
    }
  }

  @override
  void dispose() {
    _clickPlayer.dispose();
    _effectPlayer.dispose();
    Level1Bgm.stop();
    super.dispose();
  }

  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ===== BG =====
          Image.asset(
            "assets/bg_chips.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          /// ===== MAIN WHITE CONTAINER =====
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(25, 25, 25, 80),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.80),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildTopBar(),
                    const SizedBox(height: 16),
                    _buildRobotText(),
                    const SizedBox(height: 16),

                    /// ===== SOCKET ARENA (BARU) =====
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius:
                                BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.black12,
                              width: 2,
                            ),
                          ),
                          child: LayoutBuilder(
                            builder:
                                (context, constraints) {
                              if (!_initialized) {
                                _initNodes(
                                    constraints.biggest);
                              }

                              return GestureDetector(
                                onPanStart: (d) {
                                  for (var n in nodes) {
                                    if ((n.position -
                                                d.localPosition)
                                            .distance <
                                        socketSize / 2) {
                                      startNode = n;
                                      dragStart = n.position;
                                      dragCurrent =
                                          d.localPosition;
                                      break;
                                    }
                                  }
                                },
                                onPanUpdate: (d) {
                                  if (dragStart != null) {
                                    setState(() =>
                                        dragCurrent =
                                            d.localPosition);
                                  }
                                },
                                onPanEnd: (_) async {
                                  bool correct = false;

                                  if (startNode != null &&
                                      dragCurrent != null) {
                                    for (var n in nodes) {
                                      if (n != startNode &&
                                          n.color ==
                                              startNode!
                                                  .color &&
                                          (n.position -
                                                      dragCurrent!)
                                                  .distance <
                                              socketSize /
                                                  2 &&
                                          !connections.any(
                                              (c) => c
                                                  .contains(
                                                      startNode!,
                                                      n))) {
                                        connections.add(
                                          Connection(
                                              startNode!, n),
                                        );
                                        lampCount++;
                                        correct = true;
                                        await _playCorrect();
                                        _checkFinish();
                                        break;
                                      }
                                    }
                                  }

                                  if (!correct) {
                                    await _playWrong();
                                    _showBubble();
                                  }

                                  setState(() {
                                    dragStart = null;
                                    dragCurrent = null;
                                    startNode = null;
                                  });
                                },
                                child: CustomPaint(
                                  painter: SocketPainter(
                                    nodes: nodes,
                                    connections:
                                        connections,
                                    dragStart: dragStart,
                                    dragCurrent:
                                        dragCurrent,
                                  ),
                                  child: Container(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ===== BACK BUTTON =====
          Positioned(
            left: 24,
            bottom: 24,
            child: GestureDetector(
              onTap: () async {
                await _clickPlayer.play(
                    AssetSource('Audios/click.wav'));
                await Level1Bgm.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LevelSulitPage(username: widget.username),
                  ),
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
    );
  }

  /* ================= WIDGET ================= */
  Widget _buildRobotText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset(
            _showCemas
                ? "assets/cemas.png"
                : "assets/robot.png",
            height: 75,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              
              "RoboBits harus menghubungkan soket yang saling sesuai agar aliran energi kembali normal. \n "
              "Hubungkan soket yang sesuai warna !",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset("assets/refresh.png", width: 36),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4C79C5),
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: List.generate(
                      totalPairs,
                      (i) => Opacity(
                        opacity:
                            i < lampCount ? 1 : 0.3,
                        child: Image.asset(
                          "assets/lamp.png",
                          width: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: lampCount / totalPairs,
                    minHeight: 6,
                    backgroundColor:
                        Colors.white.withOpacity(0.3),
                    valueColor:
                        const AlwaysStoppedAnimation(
                            Colors.white),
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
}

/* ================= MODEL ================= */
class ColorNode {
  final Color color;
  Offset position = Offset.zero;
  ColorNode(this.color);
}

class Connection {
  final ColorNode a;
  final ColorNode b;
  Connection(this.a, this.b);

  bool contains(ColorNode x, ColorNode y) =>
      (a == x && b == y) || (a == y && b == x);
}

/* ================= PAINTER ================= */
class SocketPainter extends CustomPainter {
  final List<ColorNode> nodes;
  final List<Connection> connections;
  final Offset? dragStart;
  final Offset? dragCurrent;

  SocketPainter({
    required this.nodes,
    required this.connections,
    this.dragStart,
    this.dragCurrent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (var c in connections) {
      linePaint.color = c.a.color;
      canvas.drawLine(
          c.a.position, c.b.position, linePaint);
    }

    if (dragStart != null && dragCurrent != null) {
      linePaint.color = Colors.black26;
      canvas.drawLine(
          dragStart!, dragCurrent!, linePaint);
    }

    for (var n in nodes) {
      _drawSocket(canvas, n.position, n.color);
    }
  }

  void _drawSocket(
      Canvas canvas, Offset center, Color color) {
    final rect = Rect.fromCenter(
      center: center,
      width: socketSize,
      height: socketSize,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        const Radius.circular(10),
      ),
      Paint()..color = color.withOpacity(0.9),
    );

    final holePaint = Paint()..color = Colors.black54;
    canvas.drawCircle(
        center.translate(-6, 0), 4, holePaint);
    canvas.drawCircle(
        center.translate(6, 0), 4, holePaint);
  }

  @override
  bool shouldRepaint(_) => true;
}
