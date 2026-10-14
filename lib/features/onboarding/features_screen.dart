import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../data/app_state.dart';
import 'widgets/choice_scaffold.dart';

class _Feature {
  const _Feature(this.key, this.title, this.tag, this.body, this.icon, this.colors);
  final String key;
  final String title;
  final String tag;
  final String body;
  final IconData icon;
  final List<Color> colors;
}

const _features = [
  _Feature(
    'affirmation',
    'Daily Affirmation',
    'Mindset',
    'Start each day with a calming, personalised affirmation for your pregnancy journey.',
    Icons.favorite_rounded,
    [Color(0xFFC084FC), Color(0xFF9333EA)],
  ),
  _Feature(
    'yoga',
    'Safe Prenatal Yoga',
    'Wellness',
    'Guided yoga sessions designed for every trimester — gentle, safe and restorative.',
    Icons.directions_run_rounded,
    [Color(0xFF34D399), Color(0xFF059669)],
  ),
  _Feature(
    'tools',
    'Helpful Tracking Tools',
    'Tools',
    'Kick counts, contraction timers, weight logs and more — everything in one place.',
    Icons.article_rounded,
    [Color(0xFF38BDF8), Color(0xFF0284C7)],
  ),
];

/// "Your companion for motherhood and a holistic pregnancy" (iPhone 17 – 6).
class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  late final Set<String> _on = {...AppStateScope.of(context).features};

  @override
  Widget build(BuildContext context) {
    return ChoiceScaffold(
      title: 'Your companion for motherhood and a holistic pregnancy',
      subtitle: 'Tap to customise what matters most to you',
      onNext: () {
        AppStateScope.of(context).features = {..._on};
        Navigator.of(context).pushNamed(Routes.dueDate);
      },
      onSkip: () => Navigator.of(context).pushNamed(Routes.dueDate),
      children: [
        for (final f in _features) ...[
          _FeatureCard(
            item: f,
            checked: _on.contains(f.key),
            onTap: () => setState(() =>
                _on.contains(f.key) ? _on.remove(f.key) : _on.add(f.key)),
          ),
          const SizedBox(height: 16),
        ],
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF0E4EE)),
            ),
            child: Text(
              '${_on.length} feature${_on.length == 1 ? '' : 's'} selected',
              style: AppText.l(13,
                  weight: FontWeight.w700, color: AppColors.gray700),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.item,
    required this.checked,
    required this.onTap,
  });

  final _Feature item;
  final bool checked;
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
          border: Border.all(color: const Color(0xFFF3E6F2)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14D51065), blurRadius: 14, offset: Offset(0, 4)),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 4,
                color: checked ? accent : accent.withAlpha(0x40),
              ),
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
                        ),
                        child: Icon(item.icon, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(item.title,
                                    style: AppText.l(16,
                                        weight: FontWeight.w700,
                                        color: accent)),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: accent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(item.tag,
                                      style: AppText.l(11,
                                          weight: FontWeight.w700,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(item.body,
                                style: AppText.l(14,
                                    color: AppColors.gray600, height: 1.45)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: checked ? accent : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: checked ? accent : AppColors.gray300),
                        ),
                        child: checked
                            ? const Icon(Icons.check_rounded,
                                size: 16, color: Colors.white)
                            : null,
                      ),
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
