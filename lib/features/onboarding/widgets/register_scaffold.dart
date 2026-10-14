import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/status_bar_strip.dart';

/// Layout for the 3-step registration (Find your delivery date / Enter your
/// details / Country): pink logo header, step progress, centred title.
class RegisterScaffold extends StatelessWidget {
  const RegisterScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final int step;
  final String title;
  final String subtitle;
  final List<Widget> children;

  static const totalSteps = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StatusBarStrip(
        color: const Color(0xFFFCE4F0),
        child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _LogoHeader(top: 0),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, c) => Align(
                          alignment: Alignment.centerLeft,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(end: step / totalSteps),
                            duration: const Duration(milliseconds: 400),
                            builder: (context, v, _) => Container(
                              width: c.maxWidth * 0.75 * v + 20,
                              height: 5,
                              decoration: BoxDecoration(
                                color: AppColors.pink500,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text('$step to $totalSteps',
                        style: AppText.l(14, color: AppColors.gray700)),
                  ],
                ),
                const SizedBox(height: 38),
                Text(title,
                    textAlign: TextAlign.center,
                    style: AppText.l(21,
                        weight: FontWeight.w700, color: AppColors.gray900)),
                const SizedBox(height: 8),
                Text(subtitle,
                    textAlign: TextAlign.center,
                    style: AppText.l(16,
                        color: AppColors.gray700, height: 1.45)),
                const SizedBox(height: 26),
                ...children,
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  const _LogoHeader({required this.top});

  final double top;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: top + 170,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFCE4F0),
                    Color(0xFFF9D0E8),
                    Color(0xFFFBE8F4),
                    Color(0xFFFFE6F0),
                  ],
                  stops: [0, 0.3, 0.6, 1],
                ),
              ),
            ),
          ),
          Positioned(left: -40, top: -20, child: _glow(200, 0x2ED51065)),
          Positioned(right: -30, top: 40, child: _glow(180, 0x24FF64A0)),
          // White wave at the bottom edge
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: _WaveClipper(),
              child: Container(height: 26, color: Colors.white),
            ),
          ),
          Positioned(
            left: 16,
            top: top + 12,
            child: Material(
              color: const Color(0xCCFFFFFF),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => Navigator.of(context).maybePop(),
                child: const SizedBox(
                  width: 34,
                  height: 34,
                  child: Icon(Icons.chevron_left_rounded, size: 24),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: top + 6,
            child: Column(
              children: [
                const _DopplerRings(),
                const SizedBox(height: 4),
                Image.asset('assets/images/onboarding/logo.png', width: 264),
                const SizedBox(height: 8),
                Text('YOUR PREGNANCY COMPANION',
                    style: AppText.l(12,
                        weight: FontWeight.w700,
                        color: const Color(0xFF9B3060),
                        letterSpacing: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(double size, int argb) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Color(argb), Color(argb & 0x00FFFFFF)],
            stops: const [0, 0.7],
          ),
        ),
      );
}

class _DopplerRings extends StatelessWidget {
  const _DopplerRings();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 46,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final s in [46.0, 32.0, 18.0])
            Container(
              width: s,
              height: s,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x80F06BA8), width: 1.2),
              ),
            ),
        ],
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    return Path()
      ..moveTo(0, h * 0.55)
      ..quadraticBezierTo(w * 0.25, h * 0.1, w * 0.5, h * 0.35)
      ..quadraticBezierTo(w * 0.75, h * 0.6, w, h * 0.2)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
