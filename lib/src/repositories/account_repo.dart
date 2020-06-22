import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/providers/account_provider.dart';
import 'package:http/http.dart';

class AccountRepo {
  final _accountProvider = AccountProvider();

  Future<Response> getAllAccount() {
    return _accountProvider.getAllAccount();
  }

  Future<Response> getAccountById(int id) {
    return _accountProvider.getAccountById(id);
  }

  Future<Response> blockAccount(int id) {
    return _accountProvider.blockAccount(id);
  }

  Future<Response> activeAccount(Account account) {
    return _accountProvider.updateAccount(account);
  }
}