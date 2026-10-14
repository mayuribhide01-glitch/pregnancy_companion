import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/page_header.dart';
import '../../data/app_state.dart';
import '../../data/models.dart';
import 'paywall_screen.dart';

/// Medicine Reminders list (iPhone 17 – 24 / 26).
class MedicineListScreen extends StatelessWidget {
  const MedicineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final meds = state.medicines;
    final now = TimeOfDay.now();
    final nowMin = now.hour * 60 + now.minute;
    final upcoming = meds
        .where((m) => m.times.any((t) => t.hour * 60 + t.minute > nowMin))
        .length;

    return Scaffold(
      backgroundColor: medBackground,
      body: Column(
        children: [
          const PageHeader(
            title: 'Medicine Reminders',
            uppercase: false,
            gradient: PageHeader.premiumGradient,
          ),
          Container(
            height: 66,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFF1E6EC))),
            ),
            child: Row(
              children: [
                _Stat(value: meds.length, label: 'Today'),
                const VerticalDivider(width: 1, color: Color(0xFFF1E6EC)),
                _Stat(value: upcoming, label: 'Upcoming'),
                const VerticalDivider(width: 1, color: Color(0xFFF1E6EC)),
                const _Stat(value: 0, label: 'Missed'),
              ],
            ),
          ),
          Expanded(
            child: meds.isEmpty
                ? Center(
                    child: Text('No reminders yet — tap + to add one',
                        style: AppText.l(14, color: AppColors.gray500)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
                    itemCount: meds.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => Dismissible(
                      key: ValueKey(meds[i].id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete_outline_rounded,
                            color: Color(0xFFDC2626)),
                      ),
                      onDismissed: (_) => state.removeMedicine(meds[i].id),
                      child: MedicineCard(medicine: meds[i]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 54,
        height: 54,
        child: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed(Routes.medAdd),
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

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$value',
              style: AppText.l(19,
                  weight: FontWeight.w900, color: AppColors.pink500)),
          const SizedBox(height: 2),
          Text(label, style: AppText.l(13, color: AppColors.gray500)),
        ],
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({super.key, required this.medicine});

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final m = medicine;
    final meta = AppText.l(12.5, color: AppColors.gray500);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3E4EC)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0AD51065), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: m.color.withAlpha(0x1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: m.color.withAlpha(0x99)),
            ),
            child: Transform.rotate(
              angle: -0.6,
              child: Icon(Icons.medication_rounded, color: m.color, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(m.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.l(15,
                              weight: FontWeight.w700,
                              color: AppColors.gray900)),
                    ),
                    Text('Since ${m.since.day} ${Fmt.month(m.since)}',
                        style: AppText.l(12, color: AppColors.gray500)),
                  ],
                ),
                const SizedBox(height: 7),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: m.color.withAlpha(0x1F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${m.dose} · ${m.form}',
                      style: AppText.l(12,
                          weight: FontWeight.w700, color: m.color)),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 13, color: AppColors.gray500),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(m.times.map(Fmt.time).join(', '),
                          overflow: TextOverflow.ellipsis, style: meta),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.sync_rounded,
                        size: 13, color: AppColors.gray500),
                    const SizedBox(width: 5),
                    Text(m.frequency, style: meta),
                  ],
                ),
                if (m.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(m.notes, style: AppText.l(12, color: AppColors.gray600)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
