/// API endpoint constants for the Speaking Club app
class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String googleAuth = '/auth/google';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // User endpoints
  static const String me = '/users/me';
  static const String avatar = '/users/me/avatar';
  static const String fcmToken = '/users/me/fcm-token';
  static const String onlineUsers = '/users/online';

  // Call endpoints
  static const String callHistory = '/calls/history';
  static String callDetails(String id) => '/calls/$id';
}
