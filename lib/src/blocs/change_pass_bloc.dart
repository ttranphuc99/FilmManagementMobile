import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/repositories/authenticate_repo.dart';
import 'package:flutter/cupertino.dart';

class ChangePassBloc {
  final BuildContext _context;
  AuthRepository _repo = AuthRepository();

  ChangePassBloc(this._context);

  Future<bool> changePass(String password) async {
    try {
      var response = await _repo.changePassword(password);

      if (response.statusCode == 200) {
        return true;
      } else {
        MySnackbar.showSnackbar(_context, "Error processing from server");
      }
    } catch (e) {
      print(e);
      MySnackbar.showSnackbar(_context, "Error processing");
    }
    return false;
  }
}
