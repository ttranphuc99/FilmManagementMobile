import 'dart:convert';

import 'package:film_management/src/models/equipment_image.dart';
import 'package:film_management/src/providers/constants.dart';
import 'package:http/http.dart';

class EquipmentImageProvider {

  Future<Response> addImage(num equipmentId, List<EquipmentImage> listImg) async {
    String url = ProviderConstants.API_BASE +
        ProviderConstants.POST_EQUIPMENT_IMG_PRE +
        equipmentId.toString() +
        ProviderConstants.POST_EQUIPMENT_IMG_POST;
    String token = await ProviderConstants.getToken();

    var response = await post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
      body: jsonEncode(listImg)
    );

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }

  Future<Response> deleteImg(List<num> listId) async {
    String url = ProviderConstants.API_BASE + ProviderConstants.DELETE_EQUIPMENT_IMG;
    String token = await ProviderConstants.getToken();

    print(jsonEncode(listId));

    var response = await put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      },
      body: jsonEncode(listId)
    );

    print("${response.statusCode}");
    print("${response.body}");

    return response;
  }
}
