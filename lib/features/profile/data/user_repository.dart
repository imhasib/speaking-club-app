import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../shared/models/user.dart';
import '../../../shared/providers/core_providers.dart';

/// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(dio: apiClient.dio);
});

/// Repository for user operations
class UserRepository {
  final Dio _dio;

  UserRepository({required Dio dio}) : _dio = dio;

  /// Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiEndpoints.me);
      return User.fromJson(_unwrap(response.data));
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Update user profile
  Future<User> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.me,
        data: request.toJson(),
      );
      return User.fromJson(_unwrap(response.data));
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }

  /// Tolerate both { data: {...} } envelopes and flat payloads.
  Map<String, dynamic> _unwrap(dynamic raw) {
    final map = raw as Map<String, dynamic>;
    final inner = map['data'];
    return inner is Map<String, dynamic> ? inner : map;
  }

  /// Upload avatar image
  /// Note: Backend endpoint not yet implemented
  Future<String> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        ApiEndpoints.images,
        data: formData,
      );

      return response.data['data']['url'] as String;
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }
}
