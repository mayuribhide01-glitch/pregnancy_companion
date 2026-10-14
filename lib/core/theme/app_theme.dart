import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_text.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.pink500,
        primary: AppColors.pink500,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: AppText.lato,
    );
    return base.copyWith(
      splashFactory: InkRipple.splashFactory,
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: Colors.white,
      ),
      timePickerTheme: const TimePickerThemeData(
        backgroundColor: Colors.white,
      ),
    );
  }
}

/// Transparent status bar with dark icons. Every screen reserves the
/// device's status-bar height at the top (see `StatusBarStrip`, `PageHeader`
/// and the `SafeArea`s), so the phone's own clock/battery stay visible.
const appSystemUiStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark, // Android
  statusBarBrightness: Brightness.light, // iOS
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
);
