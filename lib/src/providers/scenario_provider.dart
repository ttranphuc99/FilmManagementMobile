import 'dart:convert';

import 'package:film_management/src/models/scenario.dart';
import 'package:http/http.dart';

import 'package:film_management/src/providers/constants.dart';

class ScenarioProvider {
  Future<Response> getAllScenario() async {
    String url = ProviderConstants.API_BASE + ProviderConstants.GET_ALL_SCENARIO;
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
    String url = ProviderConstants.API_BASE + ProviderConstants.GET_SCENARIO_BY_ID;
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

  Future<Response> addScenario(Scenario scenario) async {
    String url = ProviderConstants.API_BASE + ProviderConstants.GET_ALL_SCENARIO;
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
}