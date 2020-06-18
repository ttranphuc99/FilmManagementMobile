import 'dart:convert';

import 'package:film_management/src/models/account.dart';
import 'package:flutter/material.dart';
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
}
