import 'package:http/http.dart';

import 'package:film_management/src/providers/authenticate_provider.dart';

class AuthRepository {
  final AuthProvider _authProvider = AuthProvider();

  Future<Response> login(String username, String password) {
    return _authProvider.login(username, password);
  }
}