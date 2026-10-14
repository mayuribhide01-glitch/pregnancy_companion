import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key, required this.name, required this.week});

  final String name;
  final int week;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.pink100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline_rounded,
                size: 26, color: AppColors.pink500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: AppText.l(18,
                        weight: FontWeight.w700,
                        color: AppColors.ink,
                        height: 1.5)),
                Row(
                  children: [
                    Text('✦ ',
                        style: AppText.o(10, color: AppColors.pink500)),
                    Text('Pregnancy week $week',
                        style: AppText.o(12,
                            color: AppColors.pink500, height: 1.5)),
                  ],
                ),
              ],
            ),
          ),
          _RoundIcon(icon: Icons.notifications_none_rounded, onTap: () {}),
          const SizedBox(width: 10),
          _RoundIcon(icon: Icons.chat_bubble_outline_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pink50,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 20, color: AppColors.pink500),
        ),
      ),
    );
  }
}
