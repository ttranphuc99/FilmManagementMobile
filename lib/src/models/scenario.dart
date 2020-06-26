import 'package:film_management/src/models/account.dart';

class Scenario {
  num id;
  String name;
  String description;
  String location;
  String timeStart;
  String timeEnd;
  num recordQuantity;
  String script;
  num status;
  String createdTime;
  Account createdBy;
  String lastModifed;
  Account lastModifiedBy;

  Scenario.emptyScenario() {
    id = 0;
  }

  Scenario.fromJSON(Map<String, dynamic> json) :
    id = json['id'],
    name = json['name'],
    description = json['description'],
    location = json['location'],
    timeStart = json['timeStart'],
    timeEnd = json['timeEnd'],
    recordQuantity = json['recordQuanrtity'],
    script = json['script'],
    status = json['status'],
    createdTime = json['createdTime'],
    createdBy = json['createdBy'] != null ? Account.fromJSON(json['createdBy']) : null,
    lastModifed = json['lastModified'],
    lastModifiedBy = json['lastModifiedBy'] != null ? Account.fromJSON(json['lastModifiedBy']) : null;

  Map<String, dynamic> toJSON() => {
    'id' : id,
    'name' : name,
    'description' : description,
    'location' : location,
    'timeStart' : timeStart,
    'timeEnd' : timeEnd,
    'recordQuantity' : recordQuantity,
    'script' : script,
    'status' : status,
    'createdTime' : createdTime,
    'createdBy' : createdBy != null ? createdBy.toJson() : null,
    'lastModified' : lastModifed,
    'lastModifiedBy' : lastModifiedBy != null ? lastModifiedBy.toJson() : null
  };
}