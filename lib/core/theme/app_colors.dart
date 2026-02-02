import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF00897B); // Teal
  static const Color primaryLight = Color(0xFF4EBAAA);
  static const Color primaryDark = Color(0xFF005B4F);

  // Secondary colors
  static const Color secondary = Color(0xFFFF6F00); // Orange
  static const Color secondaryLight = Color(0xFFFFA040);
  static const Color secondaryDark = Color(0xFFC43E00);

  // Neutral colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // User status colors
  static const Color online = Color(0xFF4CAF50);
  static const Color waiting = Color(0xFFFFC107);
  static const Color inCall = Color(0xFF2196F3);
  static const Color offline = Color(0xFF9E9E9E);

  // Call screen colors
  static const Color callEndButton = Color(0xFFE53935);
  static const Color callAcceptButton = Color(0xFF4CAF50);
  static const Color callControlActive = Color(0xFFFFFFFF);
  static const Color callControlInactive = Color(0x80FFFFFF);
  static const Color callControlMuted = Color(0xFFE53935);

  // Network quality colors
  static const Color networkExcellent = Color(0xFF4CAF50);
  static const Color networkModerate = Color(0xFFFFC107);
  static const Color networkPoor = Color(0xFFE53935);
}
