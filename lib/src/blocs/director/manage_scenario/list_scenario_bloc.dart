import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/scenario.dart';
import 'package:film_management/src/repositories/scenario_repo.dart';
import 'package:rxdart/rxdart.dart';

class ListScenarioBloc {
  final _repo = ScenarioRepo();
  final PublishSubject<List<Scenario>> _list = PublishSubject<List<Scenario>>();
  final _context;
  var listResult = List<Scenario>();

  ListScenarioBloc(this._context);

  Observable get list => _list.stream;

  void close() {
    _list.close();
  }

  Future<bool> getListScenario() async {
    try {
      var response  = await _repo.getAllScenario();

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        
        var list = List<Scenario>();
        
        for (var item in body) {
          print(item['id']);
          list.add(Scenario.fromJSON(item));
        }
        listResult = list;
        _list.sink.add(list);
      } else {
        MySnackbar.showSnackbar(_context, "Error from server");
        _list.sink.add(null);
        return false;
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Process error");
      _list.sink.add(null);
      return false;
    }
    return true;
  }

  void searchByName(String search) {
    var result = listResult
        .where((element) =>
            element.name.toLowerCase().contains(search.toLowerCase()))
        .toList();
    _list.sink.add(result);
  }
}