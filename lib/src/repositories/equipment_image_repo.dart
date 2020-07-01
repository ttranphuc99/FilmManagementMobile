import 'package:film_management/src/models/equipment_image.dart';
import 'package:film_management/src/models/my_img.dart';
import 'package:film_management/src/providers/equipment_image_provider.dart';
import 'package:http/http.dart';

class EquipmentImageRepo {
  final _provider = EquipmentImageProvider();

  Future<Response> addImage(num equipmentId, List<MyImage> listImg) {
    List<EquipmentImage> list = new List<EquipmentImage>();

    for (var img in listImg) {
      if (!img.isDelete && img.isNew) {
        var result = EquipmentImage();
        result.url = img.url;
        list.add(result);
      }
    }

    print(list);
    if (list.isEmpty) return null;

    return _provider.addImage(equipmentId, list);
  }

  Future<Response> deleteImage(List<MyImage> listImg) {
    List<num> listId = List<num>();

    for (var img in listImg) {
      if (img.isDelete) {
        listId.add(img.id);
      }
    }

    if (listId.isEmpty) return null;
    print(listId);
    return _provider.deleteImg(listId);
  }
}
