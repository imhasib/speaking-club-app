import 'package:envied/envied.dart';

part 'env.g.dart';

/// Environment configuration using envied
///
/// Create a .env file in the project root with:
/// API_BASE_URL=http://localhost:3000/api
/// SOCKET_URL=http://localhost:3000
/// GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'API_BASE_URL', defaultValue: 'http://localhost:3000/api')
  static final String apiBaseUrl = _Env.apiBaseUrl;

  @EnviedField(varName: 'SOCKET_URL', defaultValue: 'http://localhost:3000')
  static final String socketUrl = _Env.socketUrl;

  @EnviedField(varName: 'GOOGLE_CLIENT_ID', defaultValue: '')
  static final String googleClientId = _Env.googleClientId;
}
