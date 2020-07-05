import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/scenario_equipment.dart';
import 'package:film_management/src/repositories/scenario_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class ListEquipmentInScenarioBloc {
  final BuildContext _context;
  final ScenarioRepo _repo = ScenarioRepo();

  ListEquipmentInScenarioBloc(this._context);

  PublishSubject<List<ScenarioEquipment>> _listEquipment = PublishSubject<List<ScenarioEquipment>>();

  Observable<List<ScenarioEquipment>> get listEquipment => _listEquipment.stream;

  void close() {
    _listEquipment.close();
  }

  Future<List<ScenarioEquipment>> getList(num scenarioId) async {
    try {
      var response = await _repo.getListEquipmentInScenario(scenarioId);

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        List<ScenarioEquipment> result = List<ScenarioEquipment>();

        for (var item in body) {
          var model = ScenarioEquipment.fromJson(item);

          var subResponse = await _repo.getAvailableQuantityEquipmentForScen(scenarioId, model.equipment.id);

          if (subResponse.statusCode == 200) {
            model.equipmentAvailable = num.parse(subResponse.body);
          } else {
            MySnackbar.showSnackbar(_context, "Error from server");
            return null;
          }

          result.add(model);
        }
        _listEquipment.sink.add(result);
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