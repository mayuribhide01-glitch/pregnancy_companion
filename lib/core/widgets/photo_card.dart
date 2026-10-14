import 'package:flutter/material.dart';

/// Rounded photo with a vertical gradient scrim and arbitrary foreground
/// content. Used by Tools tiles, Relaxation cards, Birth Stories and the
/// Home "Activities for today" grid.
class PhotoCard extends StatelessWidget {
  const PhotoCard({
    super.key,
    required this.image,
    required this.scrim,
    required this.child,
    this.radius = 16,
    this.width,
    this.height,
    this.onTap,
    this.scrimStops,
  });

  final String image;
  final List<Color> scrim;
  final List<double>? scrimStops;
  final Widget child;
  final double radius;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(radius);
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: br,
        child: Material(
          color: Colors.black12,
          child: Ink(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: scrim,
                    stops: scrimStops,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
