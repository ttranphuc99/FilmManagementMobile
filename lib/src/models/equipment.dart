import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/models/equipment_image.dart';

class Equipment {
  num id;
  String name;
  String description;
  int quantity;
  bool status;
  Account createdBy;
  String createTime;
  Account lastModifiedBy;
  String lastModified;
  List<EquipmentImage> listImages;

  Equipment.fromJSON(Map<String, dynamic> json) : 
    id = json['id'],
    name = json['name'],
    description = json['description'],
    quantity = json['quantity'],
    status = json['status'],
    createdBy = json['createdBy'] != null ? Account.fromJSON(json['createdBy']) : null,
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
    'createdBy' : createdBy != null ? createdBy.toJson() : null,
    'lastModified' : lastModified,
    'lastModifiedBy' : lastModifiedBy != null ? lastModifiedBy.toJson() : null
  };
}