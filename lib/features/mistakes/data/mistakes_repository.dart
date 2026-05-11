import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../shared/providers/core_providers.dart';
import 'mistake_models.dart';

/// Mistakes repository provider.
final mistakesRepositoryProvider = Provider<MistakesRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MistakesRepository(dio: apiClient.dio);
});

/// Repository for the My Mistakes feature.
class MistakesRepository {
  final Dio _dio;

  MistakesRepository({required Dio dio}) : _dio = dio;

  /// `GET /mistakes` — cursor-paginated list with summary header.
  Future<MistakesPage> fetchMistakes({
    MistakeCategory? category,
    bool? fixed,
    String? cursor,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.mistakes,
        queryParameters: {
          if (category != null) 'category': category.apiValue,
          if (fixed != null) 'fixed': fixed,
          if (cursor != null) 'cursor': cursor,
          'limit': limit,
        },
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return const MistakesPage(
          mistakes: [],
          summary: MistakesSummary(),
        );
      }
      return MistakesPage.fromApiResponse(data);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// `POST /mistakes/:id/mark-fixed`.
  Future<void> markFixed(String id) async {
    try {
      await _dio.post(ApiEndpoints.mistakeMarkFixed(id));
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// `POST /mistakes/:id/save-to-vocab`.
  Future<void> saveToVocab(String id) async {
    try {
      await _dio.post(ApiEndpoints.mistakeSaveToVocab(id));
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }
}
