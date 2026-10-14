import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../home_screen.dart';

/// Row of day bubbles (4–9). Days after [today] are dimmed and disabled.
class DaySelector extends StatefulWidget {
  const DaySelector({super.key, this.firstDay = 4, this.today = 7});

  final int firstDay;
  final int today;

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  late int _selected = widget.today;

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var d = widget.firstDay; d < widget.firstDay + 6; d++)
            _DayBubble(
              day: d,
              selected: d == _selected,
              future: d > widget.today,
              onTap: () => setState(() => _selected = d),
            ),
        ],
      ),
    );
  }
}

class _DayBubble extends StatelessWidget {
  const _DayBubble({
    required this.day,
    required this.selected,
    required this.future,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final bool future;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.pink500 : AppColors.dayText;
    return Opacity(
      opacity: future ? 0.4 : 1,
      child: GestureDetector(
        onTap: future ? null : onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected || future ? Colors.transparent : Colors.white,
                border: Border.all(
                  color: selected ? AppColors.pink500 : AppColors.dayBorder,
                ),
              ),
              child: Text('$day',
                  style: AppText.o(17, weight: FontWeight.w700, color: fg)),
            ),
            const SizedBox(height: 4),
            Text('Day',
                style: AppText.o(12,
                    weight: FontWeight.w600,
                    color: selected ? AppColors.pink500 : AppColors.muted)),
          ],
        ),
      ),
    );
  }
}
