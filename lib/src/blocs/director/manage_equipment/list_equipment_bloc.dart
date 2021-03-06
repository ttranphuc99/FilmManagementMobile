import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/equipment.dart';
import 'package:film_management/src/repositories/equipment_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ListEquipmentBloc {
  final EquipmentRepo _repo = EquipmentRepo();
  List<Equipment> _listData;

  final BuildContext _context;
  
  PublishSubject<List<Equipment>> _listEquipment = PublishSubject<List<Equipment>>();

  ListEquipmentBloc(this._context);

  Observable<List<Equipment>> get listEquipment => _listEquipment.stream;

  void close() {
    _listEquipment.close();
  }

  Future<List<Equipment>> getList() async {
    try {
      var response = await _repo.getAllEquipment();

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        _listData = body.map<Equipment>((equip) => Equipment.fromJSON(equip)).toList();
        _listEquipment.sink.add(_listData);
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Process error");
    }

    return _listData;
  }

  void search(String search) {
    var result = _listData
        .where((element) =>
            element.name.toLowerCase().contains(search.toLowerCase()))
        .toList();
    _listEquipment.sink.add(result);
  }
}