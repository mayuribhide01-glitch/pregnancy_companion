import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_text.dart';

/// Pink → blue gradient hero card: "YOUR JOURNEY / 1 weeks".
class JourneyCard extends StatelessWidget {
  const JourneyCard({
    super.key,
    required this.weeks,
    required this.trimester,
    required this.dueDate,
    required this.length,
    required this.weight,
  });

  final int weeks;
  final String trimester;
  final String dueDate;
  final String length;
  final String weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 219,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          // ~149° CSS angle
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(math.pi / 18),
          colors: [Color(0xFFF2599B), Color(0xFF3B93DE)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -5,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x14FFFFFF),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('YOUR JOURNEY',
                    style: AppText.o(10,
                        color: const Color(0xB3FFFFFF), letterSpacing: 2)),
                const SizedBox(height: 4),
                Text('$weeks weeks',
                    style: AppText.o(38,
                        weight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1)),
                const SizedBox(height: 6),
                Text('$trimester | $dueDate',
                    style:
                        AppText.o(12, color: const Color(0xBFFFFFFF), height: 1.5)),
                const SizedBox(height: 20),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _Stat(value: length, label: 'Length')),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _Stat(
                              value: weight, label: 'Weight', bold: true)),
                    ],
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

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.bold = false});

  final String value;
  final String label;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x26FFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: AppText.l(20,
                  weight: bold ? FontWeight.w700 : FontWeight.w400,
                  color: Colors.white,
                  height: 1.4)),
          Text(label,
              style: AppText.o(11, color: const Color(0xA6FFFFFF))),
        ],
      ),
    );
  }
}
