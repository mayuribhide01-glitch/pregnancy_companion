import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/mock_data.dart';
import '../home_screen.dart';

class MoodPicker extends StatefulWidget {
  const MoodPicker({super.key});

  @override
  State<MoodPicker> createState() => _MoodPickerState();
}

class _MoodPickerState extends State<MoodPicker> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    const moods = MockData.moods;
    return HomeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How are you feeling today?',
              style: AppText.o(18,
                  weight: FontWeight.w700, color: AppColors.ink, height: 1.33)),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: moods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 10,
              mainAxisExtent: 75,
            ),
            itemBuilder: (context, i) {
              final m = moods[i];
              final selected = _selected == i;
              return GestureDetector(
                onTap: () => setState(() => _selected = selected ? null : i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  decoration: BoxDecoration(
                    color: m.background,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? AppColors.pink500 : AppColors.moodBorder,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(m.asset, width: 32, height: 32),
                      const SizedBox(height: 6),
                      Text(m.label,
                          style: AppText.o(10, color: AppColors.moodLabel)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
