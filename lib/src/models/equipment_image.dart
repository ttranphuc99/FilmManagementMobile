import 'package:film_management/src/models/equipment.dart';

class EquipmentImage {
  num id;
  String url;
  Equipment equipment;

  EquipmentImage();

  EquipmentImage.fromJSON(Map<String, dynamic> json) :
    id = json['id'],
    url = json['url'],
    equipment = json['equipment'] != null ? Equipment.fromJSON(json['equipment']) : null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'equipment': equipment != null ? equipment.toJSON() : null
  };
}