/// API endpoint constants for the Speaking Club app
class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String googleAuth = '/auth/google';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static String resetPassword(String token) => '/auth/reset-password/$token';
  static const String changePassword = '/auth/change-password';

  // User endpoints
  static const String me = '/account/me';
  static const String onlineUsers = '/users/online';
  static const String checkUsername = '/users/check-username';

  // Image upload
  static const String images = '/images';

  // Call endpoints
  static const String callHistory = '/calls/history';
  static String callDetails(String id) => '/calls/$id';

  // WebRTC endpoints
  static const String turnCredentials = '/turn-credentials';

  // AI Practice endpoints
  static const String aiSessionToken = '/ai/session/token';
  static const String aiSessionStart = '/ai/session/start';
  static const String aiSessionEnd = '/ai/session/end';
  static const String aiSessionRefreshToken = '/ai/session/refresh-token';
  static const String aiSessions = '/ai/sessions';
  static String aiSessionDetails(String id) => '/ai/sessions/$id';
  static const String aiUsage = '/ai/usage';
  static const String aiTopics = '/ai/topics';
  static const String aiScenarios = '/ai/scenarios';
  static const String aiChatStream = '/ai/chat/stream';
  static const String aiUsageHeartbeat = '/ai/usage/heartbeat';

  // Mistakes endpoints
  static const String mistakes = '/mistakes';
  static String mistakeMarkFixed(String id) => '/mistakes/$id/mark-fixed';
  static String mistakeSaveToVocab(String id) => '/mistakes/$id/save-to-vocab';

  // Vocabulary endpoints
  static const String vocab = '/vocab';
  static const String vocabWords = '/vocab/words';
  static String vocabWordDetail(String word) => '/vocab/words/$word';

  // Streak + user stats endpoints
  static const String streak = '/users/me/streak';
  static const String userStats = '/users/me/stats';
}
