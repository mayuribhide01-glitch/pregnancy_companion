import 'package:flutter/material.dart';

import '../theme/app_text.dart';

/// "Relaxation Activities ........ All ›" style row.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.onAll,
    this.style,
  });

  final String title;
  final VoidCallback? onAll;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: style ?? AppText.sectionTitle)),
        if (onAll != null)
          GestureDetector(
            onTap: onAll,
            child: Text('All ›', style: AppText.linkAll),
          ),
      ],
    );
  }
}
