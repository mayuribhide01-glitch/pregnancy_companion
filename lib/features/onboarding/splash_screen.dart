import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/routes.dart';

/// White splash with the centred logo (iPhone 17 – 1). Moves on to Login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), _next);
  }

  void _next() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.login);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _timer?.cancel();
          _next();
        },
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => Opacity(
              opacity: t,
              child: Transform.scale(scale: 0.9 + 0.1 * t, child: child),
            ),
            child: Image.asset('assets/images/onboarding/logo.png', width: 160),
          ),
        ),
        ),
      ),
    );
  }
}
