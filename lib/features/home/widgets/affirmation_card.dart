import 'package:flutter/material.dart';

import '../../../core/theme/app_text.dart';

class AffirmationCard extends StatelessWidget {
  const AffirmationCard({super.key, required this.week, required this.quote});

  final int week;
  final String quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A5E99), Color(0xFF66ABE5)],
        ),
      ),
      child: Column(
        children: [
          Text('AFFIRMATION FOR WEEK $week',
              textAlign: TextAlign.center,
              style: AppText.o(9,
                  color: const Color(0x99FFFFFF), letterSpacing: 2)),
          const SizedBox(height: 14),
          Text(quote,
              textAlign: TextAlign.center,
              style: AppText.o(14,
                  color: Colors.white,
                  height: 1.65,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
