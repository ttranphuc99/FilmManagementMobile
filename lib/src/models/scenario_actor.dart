import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/models/scenario.dart';

class ScenarioActor {
  Scenario scenario;
  Account actor;
  String character;
  Account createdBy;
  String createdTime;
  Account lastModifiedBy;
  String lastModified;

  ScenarioActor();

  ScenarioActor.fromJson(Map<String, dynamic> json) : 
    scenario = json['scenario'] != null ? Scenario.fromJSON(json['scenario']) : null,
    actor = json['account'] != null ? Account.fromJSON(json['account']) : null,
    character = json['characters'],
    createdBy = json['createBy'] != null ? Account.fromJSON(json['createBy']) : null,
    createdTime = json['createTime'],
    lastModifiedBy = json['lastModifiedBy'] != null ? Account.fromJSON(json['lastModifiedBy']) : null,
    lastModified = json['lastModified'];

  Map<String, dynamic> toJson() => {
    'scenario': scenario != null ? scenario.toJSON() : null,
    'account': actor != null ? actor.toJson() : null,
    'characters': character,
    'createBy': createdBy != null ? createdBy.toJson() : null,
    'createTime': createdTime,
    'lastModifiedBy': lastModified != null ? lastModifiedBy.toJson() : null,
    'lastModified': lastModified
  };
}