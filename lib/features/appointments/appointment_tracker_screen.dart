import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/page_header.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import 'widgets/appointment_card.dart';

class AppointmentTrackerScreen extends StatefulWidget {
  const AppointmentTrackerScreen({super.key});

  @override
  State<AppointmentTrackerScreen> createState() =>
      _AppointmentTrackerScreenState();
}

class _AppointmentTrackerScreenState extends State<AppointmentTrackerScreen> {
  /// null == "All"
  AppointmentStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final items = state.appointmentsFor(_filter);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PageHeader(title: 'Appointment Tracker'),
          _FilterBar(
            value: _filter,
            onChanged: (f) => setState(() => _filter = f),
          ),
          Expanded(
            child: items.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => AppointmentCard(
                      appointment: items[i],
                      onDelete: () => state.removeAppointment(items[i].id),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 54,
        height: 54,
        child: FloatingActionButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.addAppointment),
          backgroundColor: AppColors.pink500,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.value, required this.onChanged});

  final AppointmentStatus? value;
  final ValueChanged<AppointmentStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = <(String, AppointmentStatus?)>[
      ('All', null),
      for (final s in AppointmentStatus.values) (s.label, s),
    ];
    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.lavenderBorder)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (label, status) = options[i];
          final active = status == value;
          return GestureDetector(
            onTap: () => onChanged(status),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 13),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.pink600 : AppColors.lavenderChip,
                borderRadius: BorderRadius.circular(21),
              ),
              child: Text(label,
                  style: AppText.l(12.5,
                      weight: FontWeight.w700,
                      color: active ? Colors.white : AppColors.gray500)),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 56),
      child: Column(
        children: [
          const Icon(Icons.calendar_today_outlined,
              size: 36, color: AppColors.gray300),
          const SizedBox(height: 14),
          Text('No appointments',
              style: AppText.l(14,
                  weight: FontWeight.w700, color: AppColors.gray700)),
          const SizedBox(height: 6),
          Text('Tap + to add your first appointment',
              style: AppText.l(12, color: AppColors.gray500)),
        ],
      ),
    );
  }
}
