import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class NavItem {
  const NavItem(this.label, this.icon, this.activeIcon);
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

const navItems = <NavItem>[
  NavItem('Home', Icons.home_outlined, Icons.home_rounded),
  NavItem('Tools', Icons.grid_view_outlined, Icons.grid_view_rounded),
  NavItem('Discover', Icons.explore_outlined, Icons.explore),
  NavItem('Community', Icons.chat_bubble_outline_rounded,
      Icons.chat_bubble_rounded),
  NavItem('Profile', Icons.person_outline_rounded, Icons.person_rounded),
];

/// Floating white pill navigation ("Component 2" in Figma): 370x76,
/// radius 28, soft layered shadow, pink-tinted active pill.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
              color: Color(0x29001929), offset: Offset(0, 6), blurRadius: 18),
          BoxShadow(
              color: Color(0x14001929), offset: Offset(0, 16), blurRadius: 40),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < navItems.length; i++)
            Expanded(
              child: _NavButton(
                item: navItems[i],
                active: i == currentIndex,
                onTap: () => onTap(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final NavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.pink500 : AppColors.muted;
    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 40,
              decoration: BoxDecoration(
                color: active ? AppColors.pink50 : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(active ? item.activeIcon : item.icon,
                  size: 22, color: color),
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.visible,
              softWrap: false,
              style: AppText.o(12, color: color, height: 1.25),
            ),
          ],
        ),
      ),
    );
  }
}
