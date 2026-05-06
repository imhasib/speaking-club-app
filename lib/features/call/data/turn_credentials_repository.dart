import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../shared/providers/core_providers.dart';

/// Provider for [TurnCredentialsRepository]
final turnCredentialsRepositoryProvider =
    Provider<TurnCredentialsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TurnCredentialsRepository(dio: apiClient.dio);
});

/// Represents a single ICE server entry returned by the backend.
class IceServerConfig {
  final String urls;
  final String? username;
  final String? credential;

  const IceServerConfig({
    required this.urls,
    this.username,
    this.credential,
  });

  factory IceServerConfig.fromJson(Map<String, dynamic> json) {
    return IceServerConfig(
      urls: json['urls'] as String,
      username: json['username'] as String?,
      credential: json['credential'] as String?,
    );
  }

  /// Converts to the map format expected by flutter_webrtc's
  /// [createPeerConnection] configuration.
  Map<String, dynamic> toWebRtcMap() {
    final map = <String, dynamic>{'urls': urls};
    if (username != null) map['username'] = username;
    if (credential != null) map['credential'] = credential;
    return map;
  }
}

/// Fetches TURN server credentials from the backend.
///
/// Always call [fetchIceServers] immediately before creating a peer
/// connection — credentials are short-lived and must not be cached
/// across calls.
class TurnCredentialsRepository {
  final Dio _dio;

  TurnCredentialsRepository({required Dio dio}) : _dio = dio;

  /// Returns a list of ICE server configs from [ApiEndpoints.turnCredentials].
  ///
  /// Throws on network/auth errors — callers are responsible for handling
  /// failures (e.g. falling back to STUN-only mode).
  Future<List<IceServerConfig>> fetchIceServers() async {
    try {
      final response = await _dio.get(ApiEndpoints.turnCredentials);
      final data = response.data as Map<String, dynamic>;
      final rawList = data['iceServers'] as List<dynamic>;
      final servers = rawList
          .map((e) => IceServerConfig.fromJson(e as Map<String, dynamic>))
          .toList();
      dev.log(
        'TurnCredentials: Fetched ${servers.length} ICE server(s) from backend',
      );
      return servers;
    } on DioException catch (e) {
      throw e.error ?? e;
    }
  }
}
