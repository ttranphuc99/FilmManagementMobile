import 'package:film_management/src/models/scenario.dart';
import 'package:film_management/src/models/scenario_actor.dart';
import 'package:film_management/src/models/scenario_equipment.dart';
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

  Future<Response> getListEquipmentInScenario(num scenarioId) {
    return _provider.getListEquipmentsInScenario(scenarioId);
  }

  Future<Response> getListActorInScenario(num scenarioId) {
    return _provider.getListActorsInScenario(scenarioId);
  }

  Future<Response> insertActorInScenario(
      num scenId, num actorId, ScenarioActor scenAc) {
    return _provider.insertActorInScenario(scenId, actorId, scenAc);
  }

  Future<Response> updateActorInScenario(
      num scenId, num actorId, ScenarioActor scenAc) {
    return _provider.updateActorInScenario(scenId, actorId, scenAc);
  }

  Future<Response> deleteActorInScenario(num scenId, num actorId) {
    return _provider.deleteActorInScenario(scenId, actorId);
  }

  Future<Response> addEquipment(
      num scenId, num equipId, ScenarioEquipment scenEquip) {
    return _provider.addEquipment(scenId, equipId, scenEquip);
  }

  Future<Response> updateEquipment(
      num scenId, num equipId, ScenarioEquipment scenEquip) {
    return _provider.updateEquipment(scenId, equipId, scenEquip);
  }

  Future<Response> deleteEquipment(num scenId, num equipId) {
    return _provider.deleteEquipment(scenId, equipId);
  }

  Future<Response> getAvailableQuantityEquipmentForScen(
      num scenId, num equipId) {
    return _provider.getAvailableQuantityEquipmentForScen(scenId, equipId);
  }

  Future<Response> getListScenOfActor() {
    return _provider.getListScenOfActor();
  }
}
