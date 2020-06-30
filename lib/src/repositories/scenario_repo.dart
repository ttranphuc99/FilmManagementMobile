import 'package:film_management/src/models/scenario.dart';
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

  Future<Response> addScenario(Scenario scenario) {
    return _provider.addScenario(scenario);
  }

  Future<Response> updateScenario(Scenario scenario) {
    return _provider.updateScenario(scenario);
  }

  Future<Response> deleteScenario(int id) {
    return _provider.deleteScenario(id);
  }
}