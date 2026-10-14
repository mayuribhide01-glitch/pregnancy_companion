import 'package:flutter/material.dart';

import '../../../core/theme/app_text.dart';
import '../../../core/widgets/photo_card.dart';
import '../../../data/mock_data.dart';
import '../../../data/models.dart';
import '../home_screen.dart';

class ActivitiesGrid extends StatelessWidget {
  const ActivitiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const items = MockData.activities;
    final done = items.fold<int>(0, (s, a) => s + a.done);
    final total = items.fold<int>(0, (s, a) => s + a.total);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text('Activities for today', style: homeTitleStyle())),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                width: 60,
                height: 5,
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : done / total,
                  backgroundColor: const Color(0xFFE5E5E5),
                  color: const Color(0xFF7A28B8),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text('$done/$total',
                style: AppText.o(12,
                    weight: FontWeight.w500, color: const Color(0xFFAAAAAA))),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 150,
          ),
          itemBuilder: (context, i) => _ActivityTile(item: items[i]),
        ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});

  final ActivityCategory item;

  @override
  Widget build(BuildContext context) {
    return PhotoCard(
      image: item.image,
      radius: 16,
      onTap: () {},
      scrim: const [
        Color(0x33EF2A7F),
        Color(0x73A60D4F),
        Color(0x9E470522),
      ],
      child: Stack(
        children: [
          const Positioned(
            top: 10,
            right: 10,
            child: Icon(Icons.info_outline_rounded,
                size: 16, color: Color(0xD9FFFFFF)),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.o(14,
                        weight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 3),
                Text('${item.done}/${item.total} tasks completed',
                    style: AppText.o(12, color: const Color(0xBFFFFFFF))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('Do now',
                        style: AppText.o(11,
                            weight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(width: 3),
                    const Icon(Icons.arrow_forward_rounded,
                        size: 10, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
