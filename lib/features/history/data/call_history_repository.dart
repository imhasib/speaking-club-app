import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../shared/models/call.dart';
import '../../../shared/providers/core_providers.dart';

/// Call history repository provider
final callHistoryRepositoryProvider = Provider<CallHistoryRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CallHistoryRepository(dio: apiClient.dio);
});

/// Paginated call history response
class PaginatedCallHistory {
  final List<Call> calls;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginatedCallHistory({
    required this.calls,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  /// Parse from API response format:
  /// { "data": [...calls...], "pagination": { "page", "limit", "total", "pages" } }
  factory PaginatedCallHistory.fromApiResponse(Map<String, dynamic> response) {
    final pagination = response['pagination'] as Map<String, dynamic>;
    return PaginatedCallHistory(
      calls: (response['data'] as List<dynamic>)
          .map((e) => Call.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: pagination['page'] as int,
      limit: pagination['limit'] as int,
      total: pagination['total'] as int,
      totalPages: pagination['pages'] as int,
    );
  }
}

/// Repository for call history operations
class CallHistoryRepository {
  final Dio _dio;

  CallHistoryRepository({required Dio dio}) : _dio = dio;

  /// Fetch paginated call history
  Future<PaginatedCallHistory> getCallHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.callHistory,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return PaginatedCallHistory.fromApiResponse(response.data);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Fetch single call details
  Future<Call> getCallDetails(String callId) async {
    try {
      final response = await _dio.get(ApiEndpoints.callDetails(callId));
      return Call.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }
}
