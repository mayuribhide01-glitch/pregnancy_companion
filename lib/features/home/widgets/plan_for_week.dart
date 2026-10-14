import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../home_screen.dart';

class PlanForWeek extends StatelessWidget {
  const PlanForWeek({super.key, this.week = 1});

  final int week;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Week $week Overview', 'Learn about your baby', AppColors.blue50),
      ('Nutrition Tips', 'Folic acid & more', AppColors.blue100),
      ('Exercise Guide', 'Safe moves for week $week', AppColors.blue200),
    ];
    return HomeCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 0, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plan for the week',
              style: AppText.o(18,
                  weight: FontWeight.w700,
                  color: AppColors.gray900,
                  height: 1.5)),
          const SizedBox(height: 14),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final (title, subtitle, color) = items[i];
                return Material(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {},
                    child: Container(
                      width: 140,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.o(14,
                                  weight: FontWeight.w600,
                                  color: AppColors.gray700)),
                          const SizedBox(height: 4),
                          Text(subtitle,
                              maxLines: 2,
                              style: AppText.o(11, color: AppColors.gray700)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
