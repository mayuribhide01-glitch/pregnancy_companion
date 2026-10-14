import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The design uses two families: Lato (titles, forms, community) and
/// Open Sans (home screen body). Segoe UI in the file is mapped to Open Sans.
class AppText {
  AppText._();

  static const lato = 'Lato';
  static const openSans = 'OpenSans';

  static TextStyle l(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.gray900,
    double? height,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: lato,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  static TextStyle o(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.gray900,
    double? height,
    double? letterSpacing,
    FontStyle fontStyle = FontStyle.normal,
  }) =>
      TextStyle(
        fontFamily: openSans,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      );

  // Common presets
  static final headerTitle =
      l(20, weight: FontWeight.w600, color: AppColors.gray900);
  static final sectionTitle =
      l(16, weight: FontWeight.w800, color: AppColors.ink);
  static final cardTitle =
      o(18, weight: FontWeight.w700, color: AppColors.ink, height: 1.4);
  static final linkAll =
      l(13, weight: FontWeight.w700, color: AppColors.pink500);
}
