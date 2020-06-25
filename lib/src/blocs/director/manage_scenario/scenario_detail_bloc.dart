import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/scenario.dart';
import 'package:film_management/src/repositories/scenario_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ScenarioDetailBloc {
  final _repo = ScenarioRepo();
  final BuildContext _context;

  final PublishSubject<Scenario> _scenarioStream = PublishSubject<Scenario>();

  ScenarioDetailBloc(this._context);

  Observable<Scenario> get scenario => _scenarioStream.stream;
  
  void close() {
    _scenarioStream.close();
  }

  Future<Scenario> getScenarioById(int id) async {
    var scen;

    try {
      var response = await _repo.getById(id);
      
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        scen = Scenario.fromJSON(body);

        _scenarioStream.sink.add(scen);
      } else {
        MySnackbar.showSnackbar(_context, "Error while loading data");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Error while processing data");
    }

    return scen;
  }
}