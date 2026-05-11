import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

const _kAvatarColors = [
  Color(0xFFCDB8FF),
  Color(0xFFA5E0FF),
  Color(0xFFFFD49A),
  Color(0xFFFFB0C8),
  Color(0xFFA0E7C8),
];

class AppAvatar extends StatelessWidget {
  final double size;
  final String name;
  final bool showOnline;
  final bool ring;

  const AppAvatar({
    super.key,
    this.size = 44,
    required this.name,
    this.showOnline = false,
    this.ring = false,
  });

  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, trimmed.length.clamp(1, 2)).toUpperCase();
  }

  Color get _bgColor {
    if (name.isEmpty) return _kAvatarColors[0];
    final idx = name.codeUnitAt(0) % _kAvatarColors.length;
    return _kAvatarColors[idx];
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = size * 0.22;
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _bgColor,
        shape: BoxShape.circle,
        border: ring
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
          height: 1,
        ),
      ),
    );

    if (!showOnline) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: AppColors.greenPrimary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
