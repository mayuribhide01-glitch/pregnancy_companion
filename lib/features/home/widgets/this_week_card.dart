import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../home_screen.dart';

/// "This Week" card with a two-option toggle and placeholder copy lines
/// (the design shows skeleton bars where the article excerpt will go).
class ThisWeekCard extends StatefulWidget {
  const ThisWeekCard({super.key});

  @override
  State<ThisWeekCard> createState() => _ThisWeekCardState();
}

class _ThisWeekCardState extends State<ThisWeekCard> {
  int _tab = 0;
  static const _tabs = ['My Body This Week', 'My Baby This Week'];
  static const _barWidths = [0.9, 0.75, 0.85, 0.6];

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This Week', style: homeTitleStyle()),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < _tabs.length; i++) ...[
                  _Pill(
                    label: _tabs[i],
                    active: i == _tab,
                    onTap: () => setState(() => _tab = i),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final w in _barWidths) ...[
                  Container(
                    width: c.maxWidth * w,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.blue50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.pink500,
              side: const BorderSide(color: AppColors.pink300),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(106, 38),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              textStyle: AppText.o(14, weight: FontWeight.w600),
            ),
            child: const Text('Read More'),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.pink400 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppText.o(14,
              weight: active ? FontWeight.w600 : FontWeight.w400,
              color: active ? Colors.white : AppColors.gray500),
        ),
      ),
    );
  }
}
