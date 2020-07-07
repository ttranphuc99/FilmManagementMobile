import 'dart:convert';

import 'package:film_management/src/models/account.dart';
import 'package:http/http.dart';

import 'package:film_management/src/providers/constants.dart';

class AuthProvider {
  Future<Response> login(
      String username, String password, String deviceToken) async {
    String url = ProviderConstants.API_BASE + ProviderConstants.LOGIN;

    Account account = Account(username, password, deviceToken);
    var body = json.encode(account.toJson());
    print(body);
    final response = await post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("${response.statusCode}");
    print("${response.body}");
    // await Future.delayed(const Duration(seconds: 2), () => "2");
    return response;
  }

  Future<Response> logout(String token) async {
    String url = ProviderConstants.API_BASE + ProviderConstants.LOGOUT;

    final response = await get(url, headers: {"Authorization": "Bearer " + token});

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }

  Future<Response> getProfile() async {
    String url = ProviderConstants.API_BASE + "/api/profile";
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

  Future<Response> changePassword(String password) async {
    String url = ProviderConstants.API_BASE + "/api/change-password";
    String token = await ProviderConstants.getToken();

    Account account = Account.emptyAccount();
    account.password = password;

    print(url);

    final response = await post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
      body: json.encode(account.toJson())
    );

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<Response> update(Account account) async {
    String url = ProviderConstants.API_BASE + "/api/profile";
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
      body: json.encode(account.toJson())
    );

    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }
}
