import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/widgets/form_widgets.dart';
import '../../../core/widgets/page_header.dart';

/// Layout for the onboarding questionnaire screens (Intention, Source,
/// Features): pink header, light-pink scrolling body and a white bottom bar
/// with Next + Skip.
class ChoiceScaffold extends StatelessWidget {
  const ChoiceScaffold({
    super.key,
    required this.title,
    required this.children,
    required this.onNext,
    required this.onSkip,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final VoidCallback? onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          PageHeader(title: title, uppercase: false),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFF0F6), Color(0xFFFFF7FA)],
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                children: [
                  if (subtitle != null) ...[
                    Text(subtitle!,
                        textAlign: TextAlign.center,
                        style: AppText.l(15, color: AppColors.gray500)),
                    const SizedBox(height: 12),
                  ],
                  ...children,
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.gray300)),
            ),
            padding: EdgeInsets.fromLTRB(
                16, 20, 16, 12 + MediaQuery.paddingOf(context).bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(label: 'Next', onPressed: onNext),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.pink500,
                    textStyle: AppText.l(18),
                  ),
                  child: const Text('Skip'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Round radio indicator used on the choice cards.
class RadioDot extends StatelessWidget {
  const RadioDot({super.key, required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: selected ? color : AppColors.gray300,
          width: selected ? 6 : 1.4,
        ),
      ),
    );
  }
}
