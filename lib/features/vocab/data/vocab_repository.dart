import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../shared/providers/core_providers.dart';
import 'vocab_models.dart';

/// Vocab repository provider.
final vocabRepositoryProvider = Provider<VocabRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VocabRepository(dio: apiClient.dio);
});

/// Repository for the Vocabulary feature.
class VocabRepository {
  final Dio _dio;

  VocabRepository({required Dio dio}) : _dio = dio;

  /// `GET /vocab` — dashboard summary (stats + sections + recent words).
  Future<VocabSummary> fetchSummary() async {
    try {
      final response = await _dio.get(ApiEndpoints.vocab);
      final raw = Map<String, dynamic>.from(
        response.data as Map<String, dynamic>,
      );
      // Guard against server returning {} instead of [] for list fields.
      for (final key in ['rarelyUsed', 'needsImprovement', 'allWords']) {
        if (raw[key] is! List) raw[key] = const [];
      }
      return VocabSummary.fromJson(raw);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// `GET /vocab/words` — cursor-paginated browser.
  Future<WordsPage> fetchWords({
    String? search,
    WordSort sort = WordSort.count,
    WordFilter filter = WordFilter.all,
    String? cursor,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.vocabWords,
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          'sort': sort.apiValue,
          'filter': filter.apiValue,
          if (cursor != null) 'cursor': cursor,
          'limit': limit,
        },
      );
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return const WordsPage(words: []);
      }
      return WordsPage.fromApiResponse(data);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// `GET /vocab/words/:word` — single word detail with full example list.
  Future<UserWord> fetchWordDetail(String word) async {
    try {
      final response = await _dio.get(ApiEndpoints.vocabWordDetail(word));
      return UserWord.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }
}
