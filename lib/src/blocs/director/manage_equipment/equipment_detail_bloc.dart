import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/equipment.dart';
import 'package:film_management/src/repositories/equipment_repo.dart';
import 'package:flutter/cupertino.dart';

class EquipmentDetailBloc {
  final EquipmentRepo _repo = EquipmentRepo();
  final BuildContext _context;

  EquipmentDetailBloc(this._context);

  Future<Equipment> getById(num id) async {
    try {
      var response = await _repo.getById(id);

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        return Equipment.fromJSON(body);
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Processing error");
    }
    return null;
  }

  Future<bool> delete(num id) async {
    try {
      var response = await _repo.deleteEquipment(id);

      if (response.statusCode == 200) {
        Navigator.of(_context).pop();
        return true;
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Processing error");
    }
    return false;
  }

  Future<bool> update(Equipment equipment) async {
    try {
      var response = await _repo.updateEquipment(equipment);

      if (response.statusCode == 200) {
        Navigator.of(_context).pop();
        return true;
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Processing error");
    }
    return false;
  }
}
