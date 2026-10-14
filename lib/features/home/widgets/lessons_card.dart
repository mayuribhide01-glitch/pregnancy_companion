import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/mock_data.dart';
import '../home_screen.dart';

/// "What is Holistic Pregnancy?" list of short video lessons.
class LessonsCard extends StatelessWidget {
  const LessonsCard({super.key});

  @override
  Widget build(BuildContext context) {
    const lessons = MockData.lessons;
    return HomeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('What is Holistic Pregnancy?',
                    style: AppText.o(18,
                        weight: FontWeight.w700,
                        color: AppColors.ink,
                        height: 1.33)),
              ),
              Text('All ›',
                  style: AppText.o(13,
                      weight: FontWeight.w600, color: AppColors.pink500)),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < lessons.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: i == lessons.length - 1
                    ? null
                    : const Border(
                        bottom: BorderSide(color: AppColors.lavenderDivider)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: lessons[i].gradient,
                      ),
                    ),
                    child: Text(lessons[i].emoji,
                        style: const TextStyle(fontSize: 26)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lessons[i].title,
                            style: AppText.o(14,
                                weight: FontWeight.w600,
                                color: AppColors.ink,
                                height: 1.5)),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded,
                                size: 12, color: AppColors.gray500),
                            const SizedBox(width: 4),
                            Text('${lessons[i].minutes} Mins',
                                style: AppText.o(12, color: AppColors.gray500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: AppColors.blue200,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {},
                      child: const SizedBox(
                        width: 38,
                        height: 38,
                        child: Icon(Icons.play_arrow_rounded,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
