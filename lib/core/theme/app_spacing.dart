import 'package:flutter/material.dart';

/// Application spacing constants based on 8px grid
class AppSpacing {
  AppSpacing._();

  // Base unit
  static const double unit = 8.0;

  // Spacing values
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Screen padding
  static const double screenPadding = 16.0;
  static const EdgeInsets screenInsets = EdgeInsets.all(16.0);
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets screenVertical = EdgeInsets.symmetric(vertical: 16.0);

  // Card padding
  static const double cardPadding = 16.0;
  static const EdgeInsets cardInsets = EdgeInsets.all(16.0);

  // List item spacing
  static const double listItemSpacing = 12.0;
  static const double gridSpacing = 12.0;

  // Border radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusRound = 999.0;

  // Card border radius
  static const double cardRadius = 12.0;
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(12.0));

  // Button border radius
  static const double buttonRadius = 24.0;
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(24.0));

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Avatar sizes
  static const double avatarXs = 24.0;
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;
  static const double avatarXl = 96.0;
  static const double avatarXxl = 128.0;

  // Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
}
