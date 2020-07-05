import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/models/equipment.dart';
import 'package:film_management/src/models/scenario.dart';

class ScenarioEquipment {
  Scenario scenario;
  Equipment equipment;
  num quantity;
  String description;
  String createdTime;
  Account createdBy;
  String lastModified;
  Account lastModifiedBy;
  num equipmentAvailable;

  ScenarioEquipment.fromJson(Map<String, dynamic> json) : 
    scenario = json['scenario'] != null ? Scenario.fromJSON(json['scenario']) : null,
    equipment = json['equipment'] != null ? Equipment.fromJSON(json['equipment']) : null,
    quantity = json['quantity'],
    description = json['description'],
    createdTime = json['createdTime'],
    createdBy = json['createdBy'] != null ? Account.fromJSON(json['createdBy']) : null,
    lastModified = json['lastModified'],
    lastModifiedBy = json['lastModifiedBy'] != null ? Account.fromJSON(json['lastModifiedBy']) : null;

  Map<String,dynamic> toJson() => {
    'scenario': scenario != null ? scenario.toJSON() : null,
    'equipment': equipment != null ? equipment.toJSON() : null,
    'quantity': quantity,
    'description': description
  };
}