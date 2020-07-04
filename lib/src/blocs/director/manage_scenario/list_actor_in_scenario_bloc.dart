import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/scenario_actor.dart';
import 'package:film_management/src/repositories/scenario_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ListActorInScenarioBloc {
  final ScenarioRepo _repo = ScenarioRepo();
  PublishSubject<List<ScenarioActor>> _listActors = PublishSubject<List<ScenarioActor>>();

  ListActorInScenarioBloc(this._context);

  Observable<List<ScenarioActor>> get listAcrtors => _listActors.stream;

  final BuildContext _context;  

  Future<List<ScenarioActor>> loadData(num scenarioId) async {
    var result = List<ScenarioActor>();
    try {
      var response = await _repo.getListActorInScenario(scenarioId);

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        result = body.map<ScenarioActor>((item) => ScenarioActor.fromJson(item)).toList();

        _listActors.sink.add(result);
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Process error");
    }
    return result;
  }

  Future<bool> insert(num scenId, num actorId, ScenarioActor scenAc) async {
    try {
      var response = await _repo.insertActorInScenario(scenId, actorId, scenAc);

      if (response.statusCode == 201) {
        return true;
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
        return false;
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Process error");
      return false;
    }
  }

  Future<bool> update(num scenId, num actorId, ScenarioActor scenAc) async {
    try {
      var response = await _repo.updateActorInScenario(scenId, actorId, scenAc);

      if (response.statusCode == 200) {
        return true;
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
        return false;
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Process error");
      return false;
    }
  }

  Future<bool> delete(num scenId, num actorId) async {
    try {
      var response = await _repo.deleteActorInScenario(scenId, actorId);

      if (response.statusCode == 200) {
        return true;
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
        return false;
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Process error");
      return false;
    }
  }

  void close() {
    _listActors.close();
  }
}