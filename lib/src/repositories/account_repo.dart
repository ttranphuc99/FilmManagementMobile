import 'package:film_management/src/providers/account_provider.dart';
import 'package:http/http.dart';

class AccountRepo {
  final _accountProvider = AccountProvider();

  Future<Response> getAllAccount() {
    return _accountProvider.getAllAccount();
  }
}