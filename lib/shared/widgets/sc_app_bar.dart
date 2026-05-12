import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ScAppBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final Widget? right;

  const ScAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 8,
        left: 4,
        right: 4,
      ),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 28),
              color: AppColors.ink,
              onPressed: () => Navigator.of(context).maybePop(),
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: -0.3,
              ),
            ),
          ),
          if (right != null)
            SizedBox(width: 48, child: right)
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}
