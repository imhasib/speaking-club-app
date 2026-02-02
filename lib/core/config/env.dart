import 'package:envied/envied.dart';

part 'env.g.dart';

/// Environment configuration using envied
///
/// Create a .env file in the project root with:
/// API_BASE_URL=http://localhost:3000/api
/// SOCKET_URL=http://localhost:3000
/// GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_BASE_URL', defaultValue: 'http://localhost:3000/api')
  static const String apiBaseUrl = _Env.apiBaseUrl;

  @EnviedField(varName: 'SOCKET_URL', defaultValue: 'http://localhost:3000')
  static const String socketUrl = _Env.socketUrl;

  @EnviedField(varName: 'GOOGLE_CLIENT_ID', defaultValue: '')
  static const String googleClientId = _Env.googleClientId;
}
