import 'package:film_management/src/models/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ListActorInScenarioBloc {
  PublishSubject<List<Account>> _listActors = PublishSubject<List<Account>>();

  ListActorInScenarioBloc(this._context);

  Observable<List<Account>> get listAcrtors => _listActors.stream;

  final BuildContext _context;  

  Future<List<Account>> loadData() {
    try {

    } catch (e) {
      
    }
  }

  void close() {
    _listActors.close();
  }
}