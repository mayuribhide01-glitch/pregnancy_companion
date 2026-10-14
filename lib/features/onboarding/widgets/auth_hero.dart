import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';

/// Photo hero shared by Login and Verification Code:
/// "TRACK / your / progress / YOUR HEALTH COMPANION" over a pink-tinted photo.
class AuthHero extends StatelessWidget {
  const AuthHero({super.key, this.showBack = false});

  final bool showBack;

  static const height = 353.0;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/onboarding/hero.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.15),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00D51065), Color(0x8CD51065)],
                stops: [0.3, 1.0],
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x1F000000), Color(0x00000000)],
                stops: [0.0, 0.5],
              ),
            ),
          ),
          // Right-hand tags
          Positioned(
            right: 16,
            top: top + 36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final t in ['TRACKING', 'TIPS', 'CARE']) ...[
                  Text('•  $t',
                      style: AppText.l(12,
                          weight: FontWeight.w700,
                          color: AppColors.pink500,
                          letterSpacing: 2.5)),
                  const SizedBox(height: 11),
                ],
              ],
            ),
          ),
          // Left-hand headline
          Positioned(
            left: 22,
            bottom: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TRACK',
                    style: AppText.l(13,
                        weight: FontWeight.w700,
                        color: const Color(0xD9FFFFFF),
                        letterSpacing: 5)),
                const SizedBox(height: 2),
                Text('your',
                    style: const TextStyle(
                      fontFamily: AppText.lato,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFFFBC4DC),
                      height: 1.05,
                    )),
                Text('progress',
                    style: AppText.l(50,
                        weight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.0,
                        letterSpacing: -1)),
                const SizedBox(height: 10),
                Text('YOUR HEALTH COMPANION',
                    style: AppText.l(12,
                        weight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 2.5)),
              ],
            ),
          ),
          if (showBack)
            Positioned(
              left: 20,
              top: top + 18,
              child: Material(
                color: const Color(0xD9FFFFFF),
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
        ],
      ),
    );
  }
}

/// Light pink page background used under the hero.
const authBackground = Color(0xFFFFF7FA);
