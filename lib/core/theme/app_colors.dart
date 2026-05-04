import 'package:flutter/material.dart';

/// Speaking Club color palette — indigo → purple brand system
class AppColors {
  AppColors._();

  // ── Primary brand ──────────────────────────────────────────────
  static const Color primary = Color(0xFF3B3B98); // Deep Indigo
  static const Color primaryLight = Color(0xFFCDB8FF); // Lavender
  static const Color primaryDark = Color(0xFF2A2752); // Night 600

  // ── Secondary brand ────────────────────────────────────────────
  static const Color secondary = Color(0xFF8E44AD); // Vibrant Purple
  static const Color secondaryLight = Color(0xFFD7A8F0); // Light purple tint
  static const Color secondaryDark = Color(0xFF6C2BB8); // Violet (gradient mid)

  // ── Accent ─────────────────────────────────────────────────────
  static const Color lavender = Color(0xFFCDB8FF); // tagline, highlights
  static const Color violet = Color(0xFF6C2BB8); // gradient mid-stop
  static const Color liveMint = Color(0xFF7CFFB2); // status dots, live indicators

  // ── Dark base (backgrounds) ────────────────────────────────────
  static const Color night900 = Color(0xFF0E0E16); // app shell
  static const Color night800 = Color(0xFF14142A); // splash top
  static const Color night700 = Color(0xFF1A1A2E); // dark backdrop
  static const Color night600 = Color(0xFF2A2752); // midtone

  // ── Neutral surfaces (light) ───────────────────────────────────
  static const Color surface = Color(0xFFFFFFFF); // cards, bubbles
  static const Color surfaceAlt = Color(0xFFFAFAFD); // page bg
  static const Color subtle = Color(0xFFF6F6F9); // inset panels
  static const Color line = Color(0xFFECECF2); // borders, dividers
  static const Color mutedInk = Color(0xFF6C6C7A); // secondary text
  static const Color ink = Color(0xFF1A1A24); // primary text

  // ── Scaffold backgrounds ───────────────────────────────────────
  static const Color background = surfaceAlt; // light scaffold
  static const Color backgroundDark = night900; // dark scaffold
  static const Color surfaceDark = night800; // dark cards/surfaces

  // ── Legacy text aliases ────────────────────────────────────────
  static const Color textPrimary = ink;
  static const Color textPrimaryDark = Color(0xFFECECF2);
  static const Color textSecondary = mutedInk;
  static const Color textSecondaryDark = Color(0xFF9090A8);

  // ── Status ─────────────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = violet; // violet for info accents

  // ── User presence ──────────────────────────────────────────────
  static const Color online = liveMint; // Live Mint — "live now"
  static const Color waiting = warning;
  static const Color inCall = primary;
  static const Color offline = mutedInk;

  // ── Call controls ──────────────────────────────────────────────
  static const Color callEndButton = error;
  static const Color callAcceptButton = success;
  static const Color callControlActive = Color(0xFFFFFFFF);
  static const Color callControlInactive = Color(0x80FFFFFF);
  static const Color callControlMuted = error;

  // ── Network quality ────────────────────────────────────────────
  static const Color networkExcellent = success;
  static const Color networkModerate = warning;
  static const Color networkPoor = error;

  // ── Brand gradients ────────────────────────────────────────────
  static const List<Color> brandGradient = [primary, secondary];
  static const List<Color> splashGradient = [night800, night700, night600, primary];
  static const List<Color> featureGradient = [night700, primary, violet, secondary];
}
