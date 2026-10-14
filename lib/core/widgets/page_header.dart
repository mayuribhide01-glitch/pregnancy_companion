import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Pink header used on every inner screen: soft pink band (or a pink → blue
/// gradient on the premium screens), two blurred circles, a frosted back
/// button and a title.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.onBack,
    this.uppercase = true,
    this.gradient,
    this.showBack = true,
  });

  final String title;

  /// Defaults to `Navigator.maybePop` when null.
  final VoidCallback? onBack;
  final bool uppercase;
  final bool showBack;

  /// Left → right gradient instead of the flat pink band.
  final List<Color>? gradient;

  /// Pink → blue header used on the premium / medicine screens.
  static const premiumGradient = [AppColors.pink100, AppColors.blue100];

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final twoLine = !uppercase && title.length > 24;
    return SizedBox(
      height: top + (twoLine ? 92 : 68),
      child: ClipRect(
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: gradient == null ? AppColors.pink100 : null,
                  gradient: gradient == null
                      ? null
                      : LinearGradient(colors: gradient!),
                ),
              ),
            ),
            if (gradient == null) ...[
              Positioned(right: -40, top: -70, child: _blob()),
              Positioned(left: 120, top: 10, child: _blob()),
            ],
            Positioned(
              left: 16,
              right: 16,
              top: top,
              bottom: 0,
              child: Row(
                children: [
                  if (showBack) ...[
                    Material(
                      color: const Color(0xB0FFFFFF),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap:
                            onBack ?? () => Navigator.of(context).maybePop(),
                        child: const SizedBox(
                          width: 33,
                          height: 33,
                          child: Icon(Icons.chevron_left_rounded,
                              size: 24, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 26),
                  ],
                  Expanded(
                    child: Text(
                      uppercase ? title.toUpperCase() : title,
                      style: AppText.headerTitle.copyWith(height: 1.25),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blob() => Container(
        width: 161,
        height: 161,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0x69FDE7F1),
        ),
      );
}
