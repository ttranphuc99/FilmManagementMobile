import 'package:film_management/src/blocs/authentication_bloc.dart';

class ProviderConstants {
  static const String API_BASE = 'https://filmmanager.azurewebsites.net';
  // static const String API_BASE = 'http://192.168.183.2:63953';

  static const String LOGIN = '/api/login';
  
  static const String LOGOUT = '/api/logout';

  static const String GENERAL_ACTORS = '/api/actors';

  static const String SPECIFIC_ACTORS = '/api/actors/';

  static const String GENERAL_ACCOUNTS = '/api/accounts';

  static const String GENERAL_SCENARIOS = '/api/scenarios';

  static const String SPECIFIC_SCENARIOS = '/api/scenarios/';

  static const String GENERAL_EQUIPMENT = '/api/equipments';

  static const String SPECIFIC_EQUIPMENT = '/api/equipments/';

  static Future<String> getToken() async{
    final _authBloc = AuthenticationBloc();
    var account = await _authBloc.getProfile();
    return account.token;
  }
}