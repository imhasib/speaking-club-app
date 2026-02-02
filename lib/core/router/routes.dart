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

  // Main app routes
  static const String home = '/';
  static const String homeName = 'home';

  static const String history = '/history';
  static const String historyName = 'history';

  static const String profile = '/profile';
  static const String profileName = 'profile';

  static const String editProfile = '/profile/edit';
  static const String editProfileName = 'editProfile';

  // Call routes
  static const String call = '/call';
  static const String callName = 'call';

  static const String incomingCall = '/call/incoming';
  static const String incomingCallName = 'incomingCall';

  static const String waiting = '/waiting';
  static const String waitingName = 'waiting';

  // User routes
  static const String userProfile = '/user/:userId';
  static const String userProfileName = 'userProfile';

  /// Get user profile path with ID
  static String userProfilePath(String userId) => '/user/$userId';
}
