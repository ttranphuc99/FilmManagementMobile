import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/scenario_actor.dart';
import 'package:film_management/src/repositories/scenario_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final BuildContext _context;
  ScenarioRepo _repo = ScenarioRepo();

  ProfileBloc(this._context);

  PublishSubject<ScenarioActor> _listScen = PublishSubject<ScenarioActor>();

  Observable<ScenarioActor> get listScen => _listScen.stream;

  void close() {
    _listScen.close();
  }

  Future<ScenarioActor> loadData() async {
    try {
      var response = await _repo.getListScenOfActor();

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        var result = body.map<ScenarioActor>((item) => ScenarioActor.fromJson(item)).toList();

        _listScen.sink.add(result);
        return result;
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Error processing");
    }
    return null;
  }
}
