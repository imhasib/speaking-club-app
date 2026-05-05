/// Route path constants
class Routes {
  Routes._();

  // Auth routes
  static const String splash = '/splash';
  static const String splashName = 'splash';

  static const String auth = '/auth';
  static const String authName = 'auth';

  static const String login = '/auth/login';
  static const String loginName = 'login';

  static const String register = '/auth/register';
  static const String registerName = 'register';

  static const String resetPassword = '/auth/reset-password/:token';
  static const String resetPasswordName = 'resetPassword';

  /// Build a concrete reset-password path for a given token.
  static String resetPasswordPath(String token) =>
      '/auth/reset-password/$token';

  static const String changePassword = '/change-password';
  static const String changePasswordName = 'changePassword';

  // Main app routes
  static const String home = '/';
  static const String homeName = 'home';

  static const String history = '/history';
  static const String historyName = 'history';

  static const String profile = '/profile';
  static const String profileName = 'profile';

  // Call routes
  static const String call = '/call';
  static const String callName = 'call';

  static const String incomingCall = '/call/incoming';
  static const String incomingCallName = 'incomingCall';

  static const String waiting = '/waiting';
  static const String waitingName = 'waiting';

  // AI Practice routes
  static const String aiPractice = '/ai-practice';
  static const String aiPracticeName = 'aiPractice';

  static const String aiSession = '/ai-practice/session';
  static const String aiSessionName = 'aiSession';

  static const String aiSummary = '/ai-practice/summary';
  static const String aiSummaryName = 'aiSummary';

  static const String aiHistory = '/ai-practice/history';
  static const String aiHistoryName = 'aiHistory';

  static const String aiSessionDetail = '/ai-practice/sessions/:sessionId';
  static const String aiSessionDetailName = 'aiSessionDetail';

  /// Build a concrete path to a session detail page.
  static String aiSessionDetailPath(String sessionId) =>
      '/ai-practice/sessions/$sessionId';

}
