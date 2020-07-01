import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/equipment.dart';
import 'package:film_management/src/repositories/equipment_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AddEquipmentBloc {
  final BuildContext _context;
  final EquipmentRepo _repo = EquipmentRepo();

  AddEquipmentBloc(this._context);

  PublishSubject<bool> _result = PublishSubject<bool>();
  Observable<bool> get result => _result.stream;

  void close() {
    _result.close();
  }
  
  Future<bool> insert(Equipment equipment) async  {
    try {
      var response = await _repo.addEquipment(equipment);

      if (response.statusCode == 201) {
        Navigator.of(_context).pop();
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
        return false;
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Processing error");
      return false;
    }
    return true;
  }
}