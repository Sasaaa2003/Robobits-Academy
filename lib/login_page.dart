import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sign_up_page.dart';
import 'home_page.dart';
import 'services/auth_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  // === CONTROLLERS ===
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _obscurePassword = true;
  bool _isPasswordFocus = false;
  bool _showCemas = false;

  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  late AnimationController _titleCtrl;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;

  late AnimationController _buttonCtrl;
  late Animation<double> _buttonScale;

  // === AUDIO ===
  Future<void> _playClick() async {
    await _audioPlayer.play(
      AssetSource('Audios/click.wav'),
    );
  }
void _showLoginError() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 GANTI ICON JADI IMAGE
            Image.asset(
              "assets/cemas.png",
              height: 80,
            ),

            const SizedBox(height: 12),

            const Text(
              "Salah email / password !",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D76EA),
                foregroundColor: Colors.white, // 🔹 text putih
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Coba Lagi"),
            )
          ],
        ),
      ),
    ),
  );
}


  @override
  void initState() {
    super.initState();

    // LOGO FLOAT
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    // TITLE
    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(_titleCtrl);
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut),
    );

    // BUTTON
    _buttonCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.92,
      upperBound: 1.0,
    );
    _buttonScale =
        CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeOut);

    _passwordFocus.addListener(() {
      setState(() {
        _isPasswordFocus = _passwordFocus.hasFocus;
      });
    });

    Future.delayed(const Duration(milliseconds: 350), () {
      _floatCtrl.repeat(reverse: true);
      _titleCtrl.forward();
      _buttonCtrl.forward();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _floatCtrl.dispose();
    _titleCtrl.dispose();
    _buttonCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _showToast() {
    setState(() => _showCemas = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFF0F0F2),
        margin: const EdgeInsets.only(bottom: 550, left: 120, right: 120),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        duration: const Duration(seconds: 2),
        content: const Text(
          "kenapa belum di isi ?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showCemas = false);
    });
  }

  String get _logoAsset {
    if (_showCemas) return "assets/cemas.png";
    if (_isPasswordFocus) return "assets/close eye.png";
    return "assets/robot.png";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/background.jpg", fit: BoxFit.cover),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // LOGO
                AnimatedBuilder(
                  animation: _floatCtrl,
                  builder: (_, __) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnim.value),
                      child: Hero(
                        tag: 'robobits-logo',
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: Image.asset(
                            _logoAsset,
                            key: ValueKey(_logoAsset),
                            height: 150,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                // TITLE
                SlideTransition(
                  position: _titleSlide,
                  child: FadeTransition(
                    opacity: _titleOpacity,
                    child: const Text(
                      "Robobits Academy",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black45,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                _field("Email", Icons.email, false,
    _usernameCtrl, null),

                const SizedBox(height: 16),
                _field("Password", Icons.lock, true,
                    _passwordCtrl, _passwordFocus),

                const SizedBox(height: 28),

                // BUTTON LOGIN
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (_) => _buttonCtrl.reverse(),
                  onTapUp: (_) => _buttonCtrl.forward(),
                  onTapCancel: () => _buttonCtrl.forward(),
                  onTap: () async {
  await _playClick();

  if (_usernameCtrl.text.isEmpty || _passwordCtrl.text.isEmpty) {
    _showToast();
    return;
  }

  try {
    final user = await AuthService().login(
      _usernameCtrl.text.trim(),
      _passwordCtrl.text.trim(),
    );

    if (user != null) {
  final username = await AuthService().getUsername();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => HomePage(username: username),
    ),
  );
} else {
  _showLoginError();
}

  }catch (e) {
  _showLoginError();
}

},



                  child: ScaleTransition(
                    scale: _buttonScale,
                    child: Container(
                      width: 160,
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
                        "Login",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // SIGN UP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style:
                          TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xFF7DC9FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String hint,
    IconData icon,
    bool isPassword,
    TextEditingController controller,
    FocusNode? focusNode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(26),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword ? _obscurePassword : false,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: Color(0xFF5CADFF)),
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: () => setState(
                        () => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                  )
                : null,
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.35),
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
