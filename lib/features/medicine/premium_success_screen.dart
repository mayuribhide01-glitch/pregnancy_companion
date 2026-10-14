import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/form_widgets.dart';
import '../../core/widgets/page_header.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import 'paywall_screen.dart';

/// "You're in Premium" / Payment Successful (iPhone 17 – 23).
class PremiumSuccessScreen extends StatelessWidget {
  const PremiumSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trial = AppStateScope.of(context).plan?.hasTrial ?? true;
    const tiles = [
      (Icons.medication_outlined, 'Track medications'),
      (Icons.calendar_today_outlined, 'Set reminders'),
      (Icons.notifications_none_rounded, 'Smart alerts'),
      (Icons.description_outlined, 'Export reports'),
    ];
    return Scaffold(
      backgroundColor: medBackground,
      body: Column(
        children: [
          const PageHeader(
            title: 'You’re in Premium',
            uppercase: false,
            gradient: PageHeader.premiumGradient,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 90, 16, 24),
              children: [
                Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.6, end: 1),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                    builder: (context, s, child) =>
                        Transform.scale(scale: s, child: child),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF0287F),
                      ),
                      child: const Icon(Icons.check_rounded,
                          size: 48, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Text('Payment Successful!',
                    textAlign: TextAlign.center,
                    style: AppText.l(22,
                        weight: FontWeight.w900, color: AppColors.gray900)),
                const SizedBox(height: 12),
                Text(
                  trial
                      ? "Your 7-day free trial has started. Let's set up your medication reminders to keep you and your baby safe."
                      : "Premium is unlocked for life. Let's set up your medication reminders to keep you and your baby safe.",
                  textAlign: TextAlign.center,
                  style: AppText.l(15, color: AppColors.gray700, height: 1.6),
                ),
                const SizedBox(height: 30),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 178 / 92,
                  children: [
                    for (final (icon, label) in tiles)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF3E4EC)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, size: 32, color: Colors.black),
                            const SizedBox(height: 10),
                            Text(label,
                                style: AppText.l(13, color: AppColors.gray900)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 26),
                PrimaryButton(
                  label: 'Set Up My Reminders',
                  bold: true,
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(Routes.medList),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
