import 'dart:convert';

import 'package:film_management/src/models/account.dart';
import 'package:http/http.dart';

import 'package:film_management/src/providers/constants.dart';

class AccountProvider {
  Future<Response> getAllAccount() async {
    String url =
        ProviderConstants.API_BASE + ProviderConstants.GENERAL_ACTORS;
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

  Future<Response> getAccountById(int id) async {
    String url = ProviderConstants.API_BASE +
        ProviderConstants.SPECIFIC_ACTORS +
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

  Future<Response> blockAccount(int id) async {
    String url = ProviderConstants.API_BASE +
        ProviderConstants.SPECIFIC_ACTORS +
        id.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await delete(
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

  Future<Response> updateAccount(Account account) async {
    String url =
        ProviderConstants.API_BASE + ProviderConstants.GENERAL_ACCOUNTS;
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
      body: json.encode(account.toJson()),
    );

    return response;
  }

  Future<Response> addActor(Account account) async {
    String url = ProviderConstants.API_BASE + ProviderConstants.GENERAL_ACTORS;
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
      body: json.encode(account.toJson()),
    );

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }
}
