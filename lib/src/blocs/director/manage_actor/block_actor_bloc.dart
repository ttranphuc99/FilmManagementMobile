import 'dart:convert';

import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/repositories/account_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class BlockActorBloc {
  final _accountRepo = AccountRepo();
  final BuildContext _context;

  PublishSubject<bool> _isLoading = PublishSubject<bool>();
  PublishSubject<bool> _isSuccess = PublishSubject<bool>();

  BlockActorBloc(this._context);

  Observable<bool> get isLoading => _isLoading.stream;
  Observable<bool> get isSuccess => _isSuccess.stream;

  void close() {
    _isLoading.close();
    _isSuccess.close();
  }

  Future<bool> blockAccount(id) async {
    _isLoading.sink.add(true);
    bool result = false;
    try {
      var response = await _accountRepo.blockAccount(id);

      if (response.statusCode == 200) {
        _isSuccess.sink.add(true);
        result = true;
      } else {
        _isSuccess.sink.add(false);
        result = false;
        MySnackbar.showSnackbar(_context, "Fetching data from server failed!");
      }
    } catch (e) {
      MySnackbar.showSnackbar(_context, "Error while processing!");
    } finally {
      _isLoading.sink.add(false);
    }
    return result;
  }

  Future<bool> activeAccount(Account account) async {
    _isLoading.sink.add(true);
    bool result = false;
    try {
      var response = await _accountRepo.activeAccount(account);

      if (response.statusCode == 200) {
        _isSuccess.sink.add(true);
        result = true;
      } else {
        _isSuccess.sink.add(false);
        result = false;
        MySnackbar.showSnackbar(_context, "Fetching data from server failed!");
      }
    } catch (e) {
      MySnackbar.showSnackbar(_context, "Error while processing!");
    } finally {
      _isLoading.sink.add(false);
    }
    return result;
  }
}