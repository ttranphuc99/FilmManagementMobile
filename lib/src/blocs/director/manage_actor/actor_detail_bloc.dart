import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/repositories/account_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ActorDetailBloc {
  final _accountRepo = AccountRepo();
  final BuildContext _context;

  final PublishSubject<bool> _isLoading = PublishSubject<bool>();
  final PublishSubject<Account> _accountInfo = PublishSubject<Account>();

  Observable<bool> get isLoading => _isLoading.stream;
  Observable<Account> get accountInfo => _accountInfo.stream;


  ActorDetailBloc(this._context);

  void dispose() {
    _isLoading.close();
    _accountInfo.close();
  }

  void fetchData(int id) async {
    _isLoading.sink.add(true);

    try {
      var response = await _accountRepo.getAccountById(id);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        Account account = Account.fromJSON(data);

        _accountInfo.sink.add(account);
      } else {
        MySnackbar.showSnackbar(_context, "Fetching data from server error!");
      }
    } catch (e) {
      MySnackbar.showSnackbar(_context, "Processing error!");
      print(e.toString());
    } finally {
      _isLoading.sink.add(false);
    }
  }
}