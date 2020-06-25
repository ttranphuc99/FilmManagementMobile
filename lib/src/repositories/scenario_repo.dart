import 'package:film_management/src/providers/scenario_provider.dart';
import 'package:http/http.dart';

class ScenarioRepo {
  final _provider = ScenarioProvider();

  Future<Response> getAllScenario() {
    return _provider.getAllScenario();
  }

  Future<Response> getById(int id) {
    return _provider.getScenarioById(id);
  }
}