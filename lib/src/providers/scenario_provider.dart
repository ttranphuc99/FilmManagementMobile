import 'dart:convert';

import 'package:film_management/src/models/scenario.dart';
import 'package:film_management/src/models/scenario_actor.dart';
import 'package:film_management/src/models/scenario_equipment.dart';
import 'package:http/http.dart';

import 'package:film_management/src/providers/constants.dart';

class ScenarioProvider {
  Future<Response> getAllScenario() async {
    String url =
        ProviderConstants.API_BASE + ProviderConstants.GENERAL_SCENARIOS;
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
    );

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }

  Future<Response> getScenarioById(int id) async {
    String url = ProviderConstants.API_BASE +
        ProviderConstants.SPECIFIC_SCENARIOS +
        id.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
    );

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }

  Future<Response> updateScenario(Scenario scenario) async {
    String url = ProviderConstants.API_BASE +
        ProviderConstants.SPECIFIC_SCENARIOS +
        scenario.id.toString();
    String token = await ProviderConstants.getToken();

    print(url);
    print(json.encode(scenario.toJSON()));

    final response = await put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
      body: json.encode(scenario.toJSON()),
    );

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }

  Future<Response> deleteScenario(int id) async {
    String url = ProviderConstants.API_BASE +
        ProviderConstants.SPECIFIC_SCENARIOS +
        id.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await delete(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    });

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }

  Future<Response> addScenario(Scenario scenario) async {
    String url =
        ProviderConstants.API_BASE + ProviderConstants.GENERAL_SCENARIOS;
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
      body: json.encode(scenario.toJSON()),
    );

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<Response> getListEquipmentsInScenario(num scenarioId) async {
    String url = ProviderConstants.API_BASE +
        ProviderConstants.IN_SCENARIO +
        scenarioId.toString() +
        ProviderConstants.EQUIPMENT_IN_SCENARIO;
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
    );

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<Response> getListActorsInScenario(num scenarioId) async {
    String url = ProviderConstants.API_BASE +
        ProviderConstants.IN_SCENARIO +
        scenarioId.toString() +
        ProviderConstants.ACTOR_IN_SCENARIO;
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
    );

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<Response> insertActorInScenario(
      num scenId, num actorId, ScenarioActor scenAc) async {
    String url = ProviderConstants.API_BASE +
        "/api/scenarios/" +
        scenId.toString() +
        "/actors/" +
        actorId.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
        body: json.encode(scenAc.toJson()));

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<Response> updateActorInScenario(
      num scenId, num actorId, ScenarioActor scenAc) async {
    String url = ProviderConstants.API_BASE +
        "/api/scenarios/" +
        scenId.toString() +
        "/actors/" +
        actorId.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await put(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
        body: json.encode(scenAc.toJson()));

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<Response> deleteActorInScenario(num scenId, num actorId) async {
    String url = ProviderConstants.API_BASE +
        "/api/scenarios/" +
        scenId.toString() +
        "/actors/" +
        actorId.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await delete(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    });

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<Response> addEquipment(
      num scenId, num equipId, ScenarioEquipment scenEquip) async {
    String url = ProviderConstants.API_BASE +
        '/api/scenarios/' +
        scenId.toString() +
        '/equipments/' +
        equipId.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
        body: json.encode(scenEquip.toJson()));

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<Response> updateEquipment(
      num scenId, num equipId, ScenarioEquipment scenEquip) async {
    String url = ProviderConstants.API_BASE +
        '/api/scenarios/' +
        scenId.toString() +
        '/equipments/' +
        equipId.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await put(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
        body: json.encode(scenEquip.toJson()));

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<Response> deleteEquipment(num scenId, num equipId) async {
    String url = ProviderConstants.API_BASE +
        '/api/scenarios/' +
        scenId.toString() +
        '/equipments/' +
        equipId.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await delete(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token
    });

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<Response> getAvailableQuantityEquipmentForScen(
      num scenId, num equipId) async {
    String url = ProviderConstants.API_BASE +
        '/api/equipments-available/' +
        equipId.toString() +
        '/scenarios/' +
        scenId.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
    );

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<Response> getListScenOfActor() async {
    String url = ProviderConstants.API_BASE + "/api/actors/scenarios";
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
    );

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }
}
