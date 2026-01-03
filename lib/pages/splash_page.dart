import 'package:flutter/material.dart';
import 'package:loyalty_cards_app/pages/home_page.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  static const Color splashBackgroundColor = Color(0xFF99ACFF);

  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _controller.forward().whenComplete(_goHome);
  }

  void _goHome() {
    if (!mounted) return;
    // replace splash with home page
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const HomePage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: splashBackgroundColor,
      body: Center(
        child: ScaleTransition(
          scale: _scale,
          child: Image.asset('assets/icons/gocards-icon-tp.png', width: 200),
        ),
      ),
    );
  }
}
