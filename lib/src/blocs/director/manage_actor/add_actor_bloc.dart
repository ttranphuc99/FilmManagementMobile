import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/repositories/account_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AddActorBloc {
  final _accountRepo = AccountRepo();
  final BuildContext _context;

  final PublishSubject<bool> _isLoading = PublishSubject<bool>();
  final PublishSubject<String> _result = PublishSubject<String>();

  Observable<bool> get isLoading => _isLoading.stream;
  Observable<String> get result => _result.stream;


  AddActorBloc(this._context);

  void dispose() {
    _isLoading.close();
    _result.close();
  }

  Future<bool> addAccount(Account account) async {
    _isLoading.sink.add(true);
    bool result = false;

    try {
      var response = await _accountRepo.createActor(account);

      if (response.statusCode == 201) {
        _result.sink.add("success");
        result = true;
        Navigator.pop(_context);
      } else if (response.statusCode == 400) {
        MySnackbar.showSnackbar(_context, account.username + "is existed!");
      } else {
        MySnackbar.showSnackbar(_context, "Insert error from server!");
      }
    } catch (e) {
      MySnackbar.showSnackbar(_context, "Processing error!");
      print(e.toString());
    } finally {
      _isLoading.sink.add(false);
    }
    return result;
  }
}