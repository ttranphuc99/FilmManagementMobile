import 'package:http/http.dart';

import 'package:film_management/src/providers/constants.dart';

class AccountProvider {
  Future<Response> getAllAccount() async {
    String url = ProviderConstants.API_BASE + ProviderConstants.GET_ALL_ACCOUNTS;
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await get(
      url,
      headers: {"Content-Type": "application/json", "Authorization" : "Bearer " + token},
    );

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }

  Future<Response> getAccountById(int id) async {
    String url = ProviderConstants.API_BASE + ProviderConstants.GET_ACCOUNT_BY_ID + id.toString();
    String token = await ProviderConstants.getToken();

    print(url);

    final response = await get(
      url,
      headers: {"Content-Type": "application/json", "Authorization" : "Bearer " + token},
    );

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }
}