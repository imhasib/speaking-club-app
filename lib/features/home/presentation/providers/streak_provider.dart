import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/streak.dart';
import '../../data/streak_repository.dart';

/// Daily streak fetch — used by the Home streak card.
final streakProvider = FutureProvider<Streak>((ref) async {
  final repo = ref.watch(streakRepositoryProvider);
  return repo.fetchStreak();
});

/// Lifetime user stats — used by the Profile stats row + head card.
final userStatsProvider = FutureProvider<UserStats>((ref) async {
  final repo = ref.watch(streakRepositoryProvider);
  return repo.fetchStats();
});
