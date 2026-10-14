import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../data/app_state.dart';
import '../shell/main_shell.dart';
import 'widgets/activities_grid.dart';
import 'widgets/affirmation_card.dart';
import 'widgets/day_selector.dart';
import 'widgets/home_top_bar.dart';
import 'widgets/journey_card.dart';
import 'widgets/lessons_card.dart';
import 'widgets/mood_picker.dart';
import 'widgets/plan_for_week.dart';
import 'widgets/this_week_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final week = state.pregnancyWeek;
    final due = state.dueDate;
    final trimester = week <= 13
        ? 'First Trimester'
        : week <= 27
            ? 'Second Trimester'
            : 'Third Trimester';
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          HomeTopBar(name: state.userName, week: week),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                  16, 0, 16, MainShell.contentBottomInset),
              children: [
                JourneyCard(
                  weeks: week,
                  trimester: trimester,
                  dueDate: due == null ? 'Due 01 May' : 'Due ${Fmt.date(due)}',
                  length: '1 inches',
                  weight: '1 g',
                ),
                const SizedBox(height: 16),
                const DaySelector(),
                const SizedBox(height: 16),
                const AffirmationCard(
                  week: 11,
                  quote:
                      '"Seven weeks. My baby is almost ready. I am almost ready. And everything between now and that meeting is preparation, not waiting."',
                ),
                const SizedBox(height: 16),
                PlanForWeek(week: week),
                const SizedBox(height: 16),
                const ThisWeekCard(),
                const SizedBox(height: 16),
                const ActivitiesGrid(),
                const SizedBox(height: 16),
                const MoodPicker(),
                const SizedBox(height: 16),
                const LessonsCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// White rounded card used by most Home sections.
class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 18, 16, 20),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

TextStyle homeTitleStyle() =>
    AppText.o(18, weight: FontWeight.w700, color: AppColors.ink, height: 1.4);
