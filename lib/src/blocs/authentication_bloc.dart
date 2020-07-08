import 'dart:convert';

import 'package:film_management/src/models/account.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:film_management/src/constants/constant.dart';

class AuthenticationBloc {
  final PublishSubject _isSessionValid = PublishSubject<bool>();
  final PublishSubject _currentRole = PublishSubject<int>();
  final PublishSubject _accountProfile = PublishSubject<Account>();

  Observable<bool> get isSessionValid => _isSessionValid.stream;
  Observable<int> get currentRole => _currentRole.stream;
  Observable<Account> get accountProfile => _accountProfile.stream;

  void dispose() {
    _isSessionValid.close();
    _currentRole.close();
    _accountProfile.close();
  }

  void restoreSession(int role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("account") != null) {
      Account account =
          Account.fromJSON(json.decode(prefs.getString("account")));

      if (account == null) {
        _isSessionValid.sink.add(false);
      } else {
        String token = account.token;
        int roleSave = account.role;

        if ((token != null && token.length > 0)) {
          if (roleSave != role) {
            _isSessionValid.sink.add(false);
          } else {
            _isSessionValid.sink.add(true);
            _currentRole.sink.add(roleSave);
          }
        } else {
          _isSessionValid.sink.add(false);
        }
      }
    }
  }

  Future<Account> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("account") != null) {
      Account account =
          Account.fromJSON(json.decode(prefs.getString("account")));
      _accountProfile.sink.add(account);
      return account;
    }
    return null;
  }

  void openSession(Account account) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("account", json.encode(account));
    _isSessionValid.sink.add(true);
    _currentRole.sink.add(account.role);
  }

  void updateSession(Account newAccount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("account") != null) {
      Account account =
          Account.fromJSON(json.decode(prefs.getString("account")));

      account.fullname = newAccount.fullname;
      account.phone = newAccount.phone;
      account.image = newAccount.image;
      account.email = newAccount.email;
      account.description = newAccount.description;

      await prefs.setString("account", json.encode(account));
    }
  }

  void closeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("account");
    _isSessionValid.sink.add(false);
    _currentRole.sink.add(AccountConstant.UNAUTHORIZE);
    _accountProfile.sink.add(null);
  }
}

final authBloc = AuthenticationBloc();
