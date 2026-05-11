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
      final raw = response.data;
      final data = raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>
          ? raw['data'] as Map<String, dynamic>
          : raw as Map<String, dynamic>;
      return VocabSummary.fromJson(data);
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
      final raw = response.data;
      final data = raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>
          ? raw['data'] as Map<String, dynamic>
          : raw as Map<String, dynamic>;
      return UserWord.fromJson(data);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }
}
