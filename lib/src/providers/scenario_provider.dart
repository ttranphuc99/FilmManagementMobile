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
}