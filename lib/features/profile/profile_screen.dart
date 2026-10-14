import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/page_header.dart';
import '../shell/main_shell.dart';

/// Placeholder — Profile isn't part of the "Home page and menu items"
/// section in Figma yet.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          title: 'Profile',
          onBack: () => MainShell.goTo(context, MainShell.home),
        ),
        Expanded(
          child: Center(
            child: Text('Profile screens coming next',
                style: AppText.l(14, color: AppColors.gray500)),
          ),
        ),
      ],
    );
  }
}
