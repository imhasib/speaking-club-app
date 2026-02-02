import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/models/auth_tokens.dart';

part 'auth_state.freezed.dart';

/// Authentication state
@freezed
class AuthState with _$AuthState {
  /// Initial state - checking authentication
  const factory AuthState.initial() = AuthStateInitial;

  /// User is authenticated
  const factory AuthState.authenticated({
    required AuthUser user,
  }) = AuthStateAuthenticated;

  /// User is not authenticated
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;

  /// Authentication is loading
  const factory AuthState.loading() = AuthStateLoading;

  /// Authentication error occurred
  const factory AuthState.error({
    required String message,
    String? code,
  }) = AuthStateError;
}

/// Extension methods for AuthState
extension AuthStateExtension on AuthState {
  /// Check if user is authenticated
  bool get isAuthenticated => this is AuthStateAuthenticated;

  /// Check if authentication is loading
  bool get isLoading => this is AuthStateLoading;

  /// Check if there's an error
  bool get hasError => this is AuthStateError;

  /// Get the authenticated user, or null if not authenticated
  AuthUser? get user => maybeMap(
        authenticated: (state) => state.user,
        orElse: () => null,
      );

  /// Get error message, or null if no error
  String? get errorMessage => maybeMap(
        error: (state) => state.message,
        orElse: () => null,
      );
}
