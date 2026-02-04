import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/models/call.dart';

part 'call_history_state.freezed.dart';

/// Call history state for managing paginated call history
@freezed
sealed class CallHistoryState with _$CallHistoryState {
  const factory CallHistoryState({
    @Default([]) List<Call> calls,
    @Default(1) int currentPage,
    @Default(0) int totalPages,
    @Default(0) int totalCalls,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasError,
    String? errorMessage,
  }) = _CallHistoryState;

  const CallHistoryState._();

  /// Whether there are more pages to load
  bool get hasMore => currentPage < totalPages;

  /// Whether the initial load has been done
  bool get isInitialized => totalCalls > 0 || (calls.isEmpty && !isLoading);

  /// Group calls by date category
  Map<DateGroup, List<Call>> get groupedCalls {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final weekAgo = today.subtract(const Duration(days: 7));

    final Map<DateGroup, List<Call>> grouped = {
      DateGroup.today: [],
      DateGroup.yesterday: [],
      DateGroup.thisWeek: [],
      DateGroup.older: [],
    };

    for (final call in calls) {
      final callDate = DateTime(
        call.startedAt.year,
        call.startedAt.month,
        call.startedAt.day,
      );

      if (callDate.isAtSameMomentAs(today)) {
        grouped[DateGroup.today]!.add(call);
      } else if (callDate.isAtSameMomentAs(yesterday)) {
        grouped[DateGroup.yesterday]!.add(call);
      } else if (callDate.isAfter(weekAgo)) {
        grouped[DateGroup.thisWeek]!.add(call);
      } else {
        grouped[DateGroup.older]!.add(call);
      }
    }

    // Remove empty groups
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }
}

/// Date grouping categories
enum DateGroup {
  today,
  yesterday,
  thisWeek,
  older;

  String get label {
    switch (this) {
      case DateGroup.today:
        return 'Today';
      case DateGroup.yesterday:
        return 'Yesterday';
      case DateGroup.thisWeek:
        return 'This Week';
      case DateGroup.older:
        return 'Older';
    }
  }
}
