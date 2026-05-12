import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../shared/models/streak.dart';
import '../../../shared/providers/core_providers.dart';

/// Streak repository provider.
final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StreakRepository(dio: apiClient.dio);
});

/// Repository for daily streak + lifetime user stats endpoints.
class StreakRepository {
  final Dio _dio;

  StreakRepository({required Dio dio}) : _dio = dio;

  Future<Streak> fetchStreak() async {
    try {
      final response = await _dio.get(ApiEndpoints.streak);
      return Streak.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  Future<UserStats> fetchStats() async {
    try {
      final response = await _dio.get(ApiEndpoints.userStats);
      return UserStats.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }
}
