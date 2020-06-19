import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/repositories/account_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ListActorBloc {
  final _accountRepo = AccountRepo();
  final BuildContext _context;

  final PublishSubject<bool> _isLoading = PublishSubject<bool>();
  final PublishSubject<List<Account>> _listAccount =
      PublishSubject<List<Account>>();

  ListActorBloc(this._context);

  Observable<bool> get isLoading => _isLoading.stream;
  Observable<List<Account>> get listAccount => _listAccount.stream;

  void dispose() {
    _isLoading.close();
    _listAccount.close();
  }

  void loadData() async {
    _isLoading.sink.add(true);

    try {
      print('begin fetch');
      
      var response = await _accountRepo.getAllAccount();

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var account;
        var list = List<Account>();

        for (var item in json) {
          account = Account.fromJSON(item);
          list.add(account);
        }

        _listAccount.sink.add(list);
      } else {
        MySnackbar.showSnackbar(_context, "Fetching data from server failed!");
      }
    } catch (e) {
      MySnackbar.showSnackbar(_context, "Error while processing!");
    } finally {
      _isLoading.sink.add(false);
    }
  }
}
