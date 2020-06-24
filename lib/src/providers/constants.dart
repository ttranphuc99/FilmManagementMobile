import 'package:film_management/src/blocs/authentication_bloc.dart';

class ProviderConstants {
  static const String API_BASE = 'https://filmmanager.azurewebsites.net';
  // static const String API_BASE = 'http://192.168.183.2:63953';

  static const String LOGIN = '/api/login';
  
  static const String LOGOUT = '/api/logout';

  static const String GET_ALL_ACCOUNTS = '/api/actors';

  static const String GET_ACCOUNT_BY_ID = '/api/actors/';

  static const String UPDATE_ACCOUNT = '/api/accounts';

  static const String GET_ALL_SCENARIO = '/api/scenarios';

  static const String GET_SCENARIO_BY_ID = '/api/scenarios/';

  static Future<String> getToken() async{
    final _authBloc = AuthenticationBloc();
    var account = await _authBloc.getProfile();
    return account.token;
  }
}