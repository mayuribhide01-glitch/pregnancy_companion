import 'package:flutter/material.dart';

/// Colour tokens taken from the Figma file (Default/pink, Default/blue,
/// Extended/cool-gray) plus the one-off colours used on each screen.
class AppColors {
  AppColors._();

  // Brand pinks
  static const pink50 = Color(0xFFFDE7F1);
  static const pink100 = Color(0xFFFFD8E8);
  static const pink300 = Color(0xFFF689B8);
  static const pink400 = Color(0xFFEF2A7F);
  static const pink500 = Color(0xFFD51065); // primary
  static const pink600 = Color(0xFFA60D4F); // active chip

  // Blues
  static const blue50 = Color(0xFFE9F3FB);
  static const blue100 = Color(0xFFBEDBF4);
  static const blue200 = Color(0xFF92C3EC);
  static const blue500 = Color(0xFF3B93DE);
  static const blue700 = Color(0xFF1A5E99);

  // Neutrals
  static const ink = Color(0xFF111111);
  static const gray900 = Color(0xFF111827);
  static const gray700 = Color(0xFF374151);
  static const gray600 = Color(0xFF4B5563);
  static const gray500 = Color(0xFF6B7280);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray100 = Color(0xFFF3F4F6);
  static const muted = Color(0xFFAAAAAA);
  static const dayBorder = Color(0xFFE0E0E0);
  static const dayText = Color(0xFF333333);
  static const moodLabel = Color(0xFF555555);

  // Lavender surfaces / borders
  static const lavenderBorder = Color(0xFFF0EBFA);
  static const lavenderChip = Color(0xFFF3F0FA);
  static const lavenderDivider = Color(0xFFF5F0FC);
  static const lavenderLine = Color(0xFFF9F5FF);
  static const statBorder = Color(0xFFEDE9F6);
  static const moodBorder = Color(0xFFF0E8FB);

  // Status pills
  static const upcomingBg = Color(0xFFE8F5E9);
  static const upcomingFg = Color(0xFF2E7D32);
  static const completedBg = Color(0xFFEDE7F6);
  static const completedFg = Color(0xFF6A1B9A);
  static const cancelledBg = Color(0xFFFFEBEE);
  static const cancelledFg = Color(0xFFC62828);

  // Tags
  static const purpleTagBg = Color(0xFFF3EEFF);
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFA855F7);
  static const hotPink = Color(0xFFEC4899);
}
