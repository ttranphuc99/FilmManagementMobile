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

  static const String POST_EQUIPMENT_IMG_PRE = '/api/equipments/';

  static const String POST_EQUIPMENT_IMG_POST = '/equipment-images';

  static const String DELETE_EQUIPMENT_IMG = '/api/equipment-images';

  static const String IN_SCENARIO = '/api/scenarios/';

  static const String EQUIPMENT_IN_SCENARIO = '/equipments';

  static const String ACTOR_IN_SCENARIO = '/actors';

  static Future<String> getToken() async{
    final _authBloc = AuthenticationBloc();
    var account = await _authBloc.getProfile();
    return account.token;
  }
}