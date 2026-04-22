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
  static const String me = '/account/me';
  static const String onlineUsers = '/users/online';

  // Image upload
  static const String images = '/images';

  // Call endpoints
  static const String callHistory = '/calls/history';
  static String callDetails(String id) => '/calls/$id';

  // AI Practice endpoints
  static const String aiSessionToken = '/ai/session/token';
  static const String aiSessionEnd = '/ai/session/end';
  static const String aiSessionRefreshToken = '/ai/session/refresh-token';
  static const String aiSessions = '/ai/sessions';
  static String aiSessionDetails(String id) => '/ai/sessions/$id';
  static const String aiUsage = '/ai/usage';
  static const String aiTopics = '/ai/topics';
  static const String aiScenarios = '/ai/scenarios';
}
