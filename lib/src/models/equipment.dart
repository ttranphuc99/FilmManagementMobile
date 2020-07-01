import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/models/equipment_image.dart';

class Equipment {
  num id;
  String name;
  String description;
  int quantity;
  bool status;
  Account createBy;
  String createTime;
  Account lastModifiedBy;
  String lastModified;
  List<EquipmentImage> listImages;

  Equipment.emptyEquipment() {
    id = -1;
  }

  Equipment.fromJSON(Map<String, dynamic> json) : 
    id = json['id'],
    name = json['name'],
    description = json['description'],
    quantity = json['quantity'],
    status = json['status'],
    createBy = json['createBy'] != null ? Account.fromJSON(json['createBy']) : null,
    createTime = json['createTime'],
    lastModified = json['lastModified'],
    lastModifiedBy = json['lastModifiedBy'] != null ? Account.fromJSON(json['lastModifiedBy']) : null,
    listImages = json['listImages'] != null ? json['listImages'].map<EquipmentImage>((img) => EquipmentImage.fromJSON(img)).toList()  as List<EquipmentImage> : null;

  Map<String, dynamic> toJSON() => {
    'id': id,
    'name': name,
    'description': description,
    'quantity': quantity,
    'status': status,
    'createTime' : createTime,
    'createBy' : createBy != null ? createBy.toJson() : null,
    'lastModified' : lastModified,
    'lastModifiedBy' : lastModifiedBy != null ? lastModifiedBy.toJson() : null
  };
}