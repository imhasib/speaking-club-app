/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Spoken Club';
  static const String appVersion = '1.0.0';

  // Validation
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int minPasswordLength = 8;
  static const int maxAvatarSizeMB = 5;

  // Token expiry
  static const int accessTokenExpiryMinutes = 15;
  static const int refreshTokenExpiryDays = 7;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxOnlineUsers = 10;

  // Call settings
  static const int callTimeoutSeconds = 30;
  static const int maxCallDurationHours = 4;

  // WebRTC
  static const List<String> stunServers = [
    'stun:stun.l.google.com:19302',
    'stun:stun1.l.google.com:19302',
  ];

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String onboardingCompleteKey = 'onboarding_complete';
}
