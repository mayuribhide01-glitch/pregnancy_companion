import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/form_widgets.dart';
import '../../core/widgets/page_header.dart';
import '../../data/models.dart';

const medBackground = Color(0xFFFFF3F8);

class _PlanInfo {
  const _PlanInfo(this.plan, this.price, this.unit, this.note, this.features,
      {this.tag, this.tagColor});
  final PremiumPlan plan;
  final String price;
  final String unit;
  final String note;
  final List<String> features;
  final String? tag;
  final Color? tagColor;
}

const _plans = [
  _PlanInfo(
    PremiumPlan.monthly,
    '\$4.99',
    '/month',
    'Billed monthly. Cancel anytime.',
    [
      'Unlimited medication reminders',
      'Smart refill alerts',
      'Caregiver sharing (1 person)',
      'Export PDF reports',
    ],
    tag: 'POPULAR',
    tagColor: AppColors.purple,
  ),
  _PlanInfo(
    PremiumPlan.annual,
    '\$2.99',
    '/month',
    'Billed \$35.99/year. Save 40%.',
    [
      'Everything in Monthly',
      'Caregiver sharing (up to 5)',
      'Drug interaction alerts',
      'Priority support',
    ],
    tag: 'BEST VALUE',
    tagColor: AppColors.pink500,
  ),
  _PlanInfo(
    PremiumPlan.lifetime,
    '\$79.99',
    'one-time',
    'Pay once, use forever.',
    [
      'Everything in Annual',
      'Lifetime updates',
      'Offline mode',
      'Dedicated support line',
    ],
  ),
];

/// Medical Reminder paywall (iPhone 17 – 19).
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  PremiumPlan _plan = PremiumPlan.monthly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: medBackground,
      body: Column(
        children: [
          const PageHeader(title: 'Medical Reminder', uppercase: false),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6D28D9), AppColors.pink500],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text('PREMIUM FEATURE',
                            style: AppText.l(13,
                                weight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.8)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Choose your plan to get started.\nUnlock smart medication tracking for your pregnancy journey',
                  textAlign: TextAlign.center,
                  style: AppText.l(14, color: AppColors.gray700, height: 1.5),
                ),
                const SizedBox(height: 16),
                for (final p in _plans) ...[
                  _PlanCard(
                    info: p,
                    selected: p.plan == _plan,
                    onTap: () => setState(() => _plan = p.plan),
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 4),
                PrimaryButton(
                  label: 'Continue with ${_plan.label}',
                  bold: true,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(Routes.medPayment, arguments: _plan),
                ),
                const SizedBox(height: 12),
                Text('7-day free trial included · Cancel anytime',
                    textAlign: TextAlign.center,
                    style: AppText.l(13,
                        weight: FontWeight.w700, color: AppColors.gray600)),
                const SizedBox(height: 6),
                Text('By continuing you agree to our Terms & Privacy Policy',
                    textAlign: TextAlign.center,
                    style: AppText.l(12, color: AppColors.gray400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.info,
    required this.selected,
    required this.onTap,
  });

  final _PlanInfo info;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.pink500 : const Color(0xFFF5E4EE),
            width: selected ? 1.8 : 1,
          ),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0FD51065), blurRadius: 14, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? AppColors.pink500 : AppColors.gray300,
                      width: selected ? 6 : 1.4,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(info.plan.label,
                      style: AppText.l(18,
                          weight: FontWeight.w700, color: AppColors.gray900)),
                ),
                Text.rich(
                  TextSpan(
                    text: info.price,
                    style: AppText.l(24,
                        weight: FontWeight.w900,
                        color:
                            selected ? AppColors.pink500 : AppColors.gray700),
                    children: [
                      TextSpan(
                        text: info.unit,
                        style: AppText.l(13, color: AppColors.gray400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info.note,
                      style: AppText.l(13, color: AppColors.gray400)),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final f in info.features)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle_rounded,
                                        size: 15,
                                        color: selected
                                            ? AppColors.purple
                                            : const Color(0xFFE2D6F7)),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(f,
                                          style: AppText.l(13.5,
                                              color: AppColors.gray700)),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (info.tag != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: info.tagColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(info.tag!,
                              style: AppText.l(11,
                                  weight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 1)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
