import 'dart:convert';

import 'package:film_management/src/models/equipment.dart';
import 'package:http/http.dart';

import 'package:film_management/src/providers/constants.dart';

class EquipmentProvider {
  Future<Response> getAllEquipment() async {
    String url =
        ProviderConstants.API_BASE + ProviderConstants.GENERAL_EQUIPMENT;
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

  Future<Response> getEquipmentById(int id) async {
    String url = ProviderConstants.API_BASE +
        ProviderConstants.SPECIFIC_EQUIPMENT +
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

  Future<Response> updateEquipment(Equipment equipment) async {
    String url = ProviderConstants.API_BASE +
        ProviderConstants.SPECIFIC_EQUIPMENT +
        equipment.id.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
      body: json.encode(equipment.toJSON()),
    );

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }

  Future<Response> deleteEquipment(Equipment equipment) async {
    String url = ProviderConstants.API_BASE +
        ProviderConstants.SPECIFIC_EQUIPMENT +
        equipment.id.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      }
    );

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }

  Future<Response> addEquipment(Equipment equipment) async {
    String url =
        ProviderConstants.API_BASE + ProviderConstants.GENERAL_EQUIPMENT;
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
      body: json.encode(equipment.toJSON()),
    );

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }
}
