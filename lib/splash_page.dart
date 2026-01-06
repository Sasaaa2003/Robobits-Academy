import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _moveController;
  late AnimationController _rotateController;
  late AnimationController _floatController;

  late Animation<Offset> _slideUp;
  late Animation<double> _scaleDown;
  late Animation<double> _rotation;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();

    // === MOVE + SCALE ===
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 1.2), // 🔥 lebih halus di Android
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _moveController, curve: Curves.easeOut),
    );

    _scaleDown = Tween<double>(
      begin: 1.6,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _moveController, curve: Curves.easeOutBack),
    );

    // === ROTATION ===
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _rotation = Tween<double>(
      begin: 0,
      end: 1, // 1x putaran
    ).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    // === FLOAT ===
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _floatAnim = Tween<double>(
      begin: -6,
      end: 6,
    ).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // === START AFTER FIRST FRAME (WAJIB ANDROID) ===
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveController.forward().then((_) {
        _rotateController.forward().then((_) {
          _floatController.repeat(reverse: true);

          Future.delayed(const Duration(milliseconds: 1600), () {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              _fadeRoute(const LoginPage()),
            );
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _moveController.dispose();
    _rotateController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Route _fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, animation, __) =>
          FadeTransition(opacity: animation, child: page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _moveController,
              _rotateController,
              _floatController,
            ]),
            builder: (_, __) {
              return Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: SlideTransition(
                  position: _slideUp,
                  child: RotationTransition(
                    turns: _rotation,
                    child: ScaleTransition(
                      scale: _scaleDown,
                      child: Hero(
                        tag: 'robobits-logo',
                        child: Image.asset(
                          "assets/robot.png",
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
