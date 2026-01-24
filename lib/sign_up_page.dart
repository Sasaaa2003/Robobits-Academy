import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'services/auth_service.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with TickerProviderStateMixin {
  // === CONTROLLERS ===
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playClick() async {
  await _audioPlayer.play(
    AssetSource('Audios/click.wav'),
  );
}



  bool _obscurePass = true;
  bool _obscureConfirm = true;

  bool _isPasswordFocus = false;
  bool _showCemas = false;

  // === LOGO FLOAT ===
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  // === TITLE ANIM ===
  late AnimationController _titleCtrl;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;

  @override
  void initState() {
    super.initState();

    _floatCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    _titleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _titleOpacity =
        Tween<double>(begin: 0, end: 1).animate(_titleCtrl);
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut),
    );

    _passFocus.addListener(_checkFocus);
    _confirmFocus.addListener(_checkFocus);

    Future.delayed(const Duration(milliseconds: 350), () {
      _floatCtrl.repeat(reverse: true);
      _titleCtrl.forward();
    });
  }

  void _checkFocus() {
    setState(() {
      _isPasswordFocus =
          _passFocus.hasFocus || _confirmFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _titleCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  // === TOAST + CEMAS ===
  void _showToast() {
    setState(() => _showCemas = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color.fromARGB(255, 239, 240, 242),
        margin: const EdgeInsets.only(bottom: 570, left: 120, right: 120),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        duration: const Duration(seconds: 2),
        content: const Text(
          "lengkapi dulu yaa !!",
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

  // === LOGO STATE ===
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
                // === HERO LOGO ===
                AnimatedBuilder(
                  animation: _floatCtrl,
                  builder: (_, __) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnim.value),
                      child: Hero(
                        tag: 'robobits-logo',
                        child: Image.asset(
                          _logoAsset,
                          height: 140,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                

                const SizedBox(height: 30),

                _field("Username", Icons.person, _usernameCtrl),
                const SizedBox(height: 14),
                _field("Email", Icons.email, _emailCtrl),
                const SizedBox(height: 14),
                _passwordField(
                  "Password",
                  _passwordCtrl,
                  _passFocus,
                  _obscurePass,
                  () => setState(() => _obscurePass = !_obscurePass),
                ),
                const SizedBox(height: 14),
                _passwordField(
                  "Confirm Password",
                  _confirmCtrl,
                  _confirmFocus,
                  _obscureConfirm,
                  () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),

                const SizedBox(height: 26),

                // === SIGN UP BUTTON ===
                GestureDetector(
                  onTap: () async {
  await _playClick();

  if (_usernameCtrl.text.isEmpty ||
      _emailCtrl.text.isEmpty ||
      _passwordCtrl.text.isEmpty ||
      _confirmCtrl.text.isEmpty) {
    _showToast();
    return;
  }

  if (_passwordCtrl.text != _confirmCtrl.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password tidak sama")),
    );
    return;
  }

  final msg = await AuthService().register(
    _emailCtrl.text,
    _passwordCtrl.text,
    _usernameCtrl.text,
  );

  if (msg == null) {
    Navigator.pop(context); // balik ke login
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
},

                  child: Container(
                    width: 170,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 78, 176, 225),
                          Color.fromARGB(255, 45, 118, 234),
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
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style:
                          TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: ()
                       => Navigator.pop(context),
                      child: const Text(
                        "Login",
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

  Widget _field(String hint, IconData icon, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(26),
        ),
        child: TextField(
          controller: ctrl,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon:
                Icon(icon, size: 20, color: const Color(0xFF5CADFF)),
            hintText: hint,
            hintStyle:
                TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.35)),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _passwordField(
    String hint,
    TextEditingController ctrl,
    FocusNode focus,
    bool obscure,
    VoidCallback toggle,
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
          controller: ctrl,
          focusNode: focus,
          obscureText: obscure,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon:
                const Icon(Icons.lock, size: 20, color: Color(0xFF5CADFF)),
            suffixIcon: GestureDetector(
              onTap: toggle,
              child: Icon(
                obscure
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                size: 18,
                color: Colors.grey,
              ),
            ),
            hintText: hint,
            hintStyle:
                TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.35)),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
