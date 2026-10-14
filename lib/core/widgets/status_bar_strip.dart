import 'package:flutter/material.dart';

/// Reserves the phone's status-bar height at the top of a screen and paints
/// it [color], then lays out [child] underneath with the top inset removed —
/// so scrolling content never slides under the clock / battery icons.
class StatusBarStrip extends StatelessWidget {
  const StatusBarStrip({
    super.key,
    required this.child,
    this.color = Colors.white,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Column(
      children: [
        Container(height: top, color: color),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ],
    );
  }
}
