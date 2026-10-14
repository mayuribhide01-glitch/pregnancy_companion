import 'package:flutter/material.dart';

import '../../core/widgets/bottom_nav_bar.dart';
import '../community/community_screen.dart';
import '../discover/discover_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../tools/tools_screen.dart';

/// Hosts the five bottom-nav tabs and the floating nav bar.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  /// Switch tabs from anywhere below the shell, e.g. `MainShell.goTo(context, 1)`.
  static void goTo(BuildContext context, int index) =>
      context.findAncestorStateOfType<_MainShellState>()?.select(index);

  static const home = 0, tools = 1, discover = 2, community = 3, profile = 4;

  /// Space screens should leave at the bottom so content clears the nav bar.
  static const contentBottomInset = 110.0;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  void select(int i) {
    if (i != _index) setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return PopScope(
      canPop: _index == MainShell.home,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) select(MainShell.home);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: IndexedStack(
                index: _index,
                children: const [
                  HomeScreen(),
                  ToolsScreen(),
                  DiscoverScreen(),
                  CommunityScreen(),
                  ProfileScreen(),
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 13 + bottom,
              child: BottomNavBar(currentIndex: _index, onTap: select),
            ),
          ],
        ),
      ),
    );
  }
}
