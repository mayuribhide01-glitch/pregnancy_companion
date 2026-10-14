import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../data/app_state.dart';
import 'widgets/choice_scaffold.dart';

class _Intention {
  const _Intention(this.title, this.body, this.icon, this.colors);
  final String title;
  final String body;
  final IconData icon;
  final List<Color> colors;
}

const _intentions = [
  _Intention(
    'Emotional Well-being',
    'Stay emotionally supported with tools to reduce stress and promote a positive pregnancy journey.',
    Icons.sentiment_satisfied_alt_rounded,
    [Color(0xFFC084FC), Color(0xFF8B5CF6)],
  ),
  _Intention(
    'Physical Wellness',
    "Monitor your health and track your baby's growth throughout every stage of pregnancy.",
    Icons.directions_run_rounded,
    [Color(0xFF34D399), Color(0xFF10B981)],
  ),
  _Intention(
    'Eat Healthier',
    "Receive personalized nutrition guidance to support you and your baby's development.",
    Icons.fastfood_rounded,
    [Color(0xFFFDBA74), Color(0xFFF97316)],
  ),
  _Intention(
    'Be Informed',
    'Access trusted, stage-by-stage insights to make confident decisions during your pregnancy.',
    Icons.info_rounded,
    [Color(0xFF7DD3FC), Color(0xFF0EA5E9)],
  ),
];

/// "What's Your Intention?" (iPhone 17 – 3).
class IntentionScreen extends StatefulWidget {
  const IntentionScreen({super.key});

  @override
  State<IntentionScreen> createState() => _IntentionScreenState();
}

class _IntentionScreenState extends State<IntentionScreen> {
  int? _selected;

  void _next() {
    if (_selected != null) {
      AppStateScope.of(context).intention = _intentions[_selected!].title;
    }
    Navigator.of(context).pushNamed(Routes.source);
  }

  @override
  Widget build(BuildContext context) {
    return ChoiceScaffold(
      title: 'What’s Your Intention?',
      onNext: _selected == null ? null : _next,
      onSkip: () => Navigator.of(context).pushNamed(Routes.source),
      children: [
        for (var i = 0; i < _intentions.length; i++) ...[
          _IntentionCard(
            item: _intentions[i],
            selected: _selected == i,
            onTap: () => setState(() => _selected = i),
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _IntentionCard extends StatelessWidget {
  const _IntentionCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _Intention item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = item.colors.last;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? accent : const Color(0xFFEBDDF8),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: accent.withAlpha(0x33),
                      blurRadius: 16,
                      offset: const Offset(0, 6)),
                ]
              : null,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accent.withAlpha(0x66)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 18, 14, 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: item.colors,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: accent.withAlpha(0x40),
                                blurRadius: 10,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Icon(item.icon, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title,
                                style: AppText.l(17,
                                    weight: FontWeight.w700,
                                    color: AppColors.gray900)),
                            const SizedBox(height: 8),
                            Text(item.body,
                                style: AppText.l(13,
                                    color: AppColors.gray600, height: 1.55)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      RadioDot(selected: selected, color: AppColors.pink500),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
