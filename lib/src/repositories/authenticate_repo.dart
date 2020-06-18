import 'package:http/http.dart';

import 'package:film_management/src/providers/authenticate_provider.dart';

class AuthRepository {
  final AuthProvider _authProvider = AuthProvider();

  Future<Response> login(String username, String password, String deviceToken) {
    return _authProvider.login(username, password, deviceToken);
  }

  Future<Response> logout(String token) {
    return _authProvider.logout(token);
  }
}