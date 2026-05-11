import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ScFilterChipData {
  final String label;
  final String? count;
  final Color? accentDot;

  const ScFilterChipData({
    required this.label,
    this.count,
    this.accentDot,
  });
}

class ScFilterChipBar extends StatelessWidget {
  final List<ScFilterChipData> chips;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ScFilterChipBar({
    super.key,
    required this.chips,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(chips.length, (i) {
          final chip = chips[i];
          final isActive = i == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.ink : AppColors.surface,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: isActive ? AppColors.ink : AppColors.line,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (chip.accentDot != null) ...[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: chip.accentDot,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      chip.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isActive ? AppColors.surface : AppColors.ink,
                      ),
                    ),
                    if (chip.count != null) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.surface.withValues(alpha: 0.2)
                              : AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          chip.count!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? AppColors.surface
                                : AppColors.mutedInk,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
