import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onDelete,
  });

  final Appointment appointment;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final a = appointment;
    final meta = AppText.l(12.5, color: AppColors.gray500);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.lavenderBorder),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.blue100, AppColors.blue500],
                  ),
                ),
                child: const Icon(Icons.calendar_month_outlined,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(a.provider,
                            style: AppText.l(14.5,
                                weight: FontWeight.w700,
                                color: AppColors.gray900)),
                        StatusPill(status: a.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _SpecialtyTag(a.specialty),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 12, color: AppColors.gray400),
                        const SizedBox(width: 5),
                        Text(Fmt.date(a.date), style: meta),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time_rounded,
                            size: 12, color: AppColors.gray400),
                        const SizedBox(width: 5),
                        Text(Fmt.time(a.time), style: meta),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppColors.gray400),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(a.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: meta),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _MoreMenu(onDelete: onDelete),
            ],
          ),
          if (a.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.lavenderLine),
            const SizedBox(height: 10),
            Text(a.notes, style: AppText.l(12.5, color: AppColors.gray400)),
          ],
        ],
      ),
    );
  }
}

class _MoreMenu extends StatelessWidget {
  const _MoreMenu({this.onDelete});

  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 24,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        tooltip: 'More',
        color: Colors.white,
        icon: const Icon(Icons.more_horiz_rounded,
            color: AppColors.gray400, size: 20),
        onSelected: (v) {
          if (v == 'delete') onDelete?.call();
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      AppointmentStatus.upcoming => (AppColors.upcomingBg, AppColors.upcomingFg),
      AppointmentStatus.completed => (
          AppColors.completedBg,
          AppColors.completedFg
        ),
      AppointmentStatus.cancelled => (
          AppColors.cancelledBg,
          AppColors.cancelledFg
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(status.label,
          style: AppText.l(10.4, weight: FontWeight.w700, color: fg)),
    );
  }
}

class _SpecialtyTag extends StatelessWidget {
  const _SpecialtyTag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final isObgyn = label == 'OB-GYN';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: isObgyn ? AppColors.blue50 : AppColors.purpleTagBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: AppText.l(12.5,
              weight: FontWeight.w600,
              color: isObgyn ? AppColors.blue700 : AppColors.purple)),
    );
  }
}
