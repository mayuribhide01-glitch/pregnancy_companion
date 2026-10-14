import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../data/app_state.dart';
import 'widgets/choice_scaffold.dart';

class _Source {
  const _Source(this.title, this.body, this.icon, this.color);
  final String title;
  final String body;
  final IconData icon;
  final Color color;
}

const _sources = [
  _Source('Family / Friend', 'Heard about it through someone close',
      Icons.people_alt_rounded, Color(0xFF8B5CF6)),
  _Source('Healthcare Professional', 'Recommended by a doctor or midwife',
      Icons.badge_rounded, Color(0xFF0EA5E9)),
  _Source('Google Search', 'Found it while searching online',
      Icons.search_rounded, Color(0xFFF59E0B)),
  _Source('App Store', 'Discovered while browsing apps', Icons.apple,
      Color(0xFF10B981)),
  _Source('Facebook', 'Saw it in a post or group', Icons.facebook,
      Color(0xFF3B82F6)),
  _Source('Instagram', 'Came across it on a reel or story',
      Icons.camera_alt_outlined, Color(0xFFEC4899)),
  _Source('Other', 'Discovered it through another way',
      Icons.more_horiz_rounded, Color(0xFF6B7280)),
];

/// "Where did you learn about Holistic Pregnancy" (iPhone 17 – 5).
class SourceScreen extends StatefulWidget {
  const SourceScreen({super.key});

  @override
  State<SourceScreen> createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return ChoiceScaffold(
      title: 'Where did you learn about Holistic Pregnancy',
      subtitle: 'Choose one that best describes you',
      onNext: () {
        AppStateScope.of(context).referralSource = _sources[_selected].title;
        Navigator.of(context).pushNamed(Routes.features);
      },
      onSkip: () => Navigator.of(context).pushNamed(Routes.features),
      children: [
        for (var i = 0; i < _sources.length; i++) ...[
          _SourceTile(
            item: _sources[i],
            selected: i == _selected,
            onTap: () => setState(() => _selected = i),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _Source item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? const Color(0xFFE9DDFB) : const Color(0xFFF3EAF6)),
          boxShadow: selected
              ? const [
                  BoxShadow(
                      color: Color(0x298B5CF6),
                      blurRadius: 18,
                      offset: Offset(0, 6)),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? item.color : item.color.withAlpha(0x26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon,
                  size: 22, color: selected ? Colors.white : item.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: AppText.l(16,
                          weight: FontWeight.w700, color: AppColors.gray900)),
                  const SizedBox(height: 4),
                  Text(item.body,
                      style: AppText.l(13, color: AppColors.gray500)),
                ],
              ),
            ),
            RadioDot(selected: selected, color: AppColors.pink500),
          ],
        ),
      ),
    );
  }
}
