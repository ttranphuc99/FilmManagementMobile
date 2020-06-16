import 'package:film_management/src/blocs/authentication_bloc.dart';
import 'package:film_management/src/repositories/authenticate_repo.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/constants/screen-routes.dart';
import 'package:film_management/src/constants/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

class LoginBloc {
  final AuthRepository _authRepository = AuthRepository();

  final PublishSubject<bool> _isLoading = PublishSubject<bool>();
  final PublishSubject<String> _loginResult = PublishSubject<String>();
  final PublishSubject _errorUsername = PublishSubject<String>();
  final PublishSubject _errorPassword = PublishSubject<String>();

  Stream<bool> get isLoading => _isLoading.stream;
  Stream<String> get loginResult => _loginResult.stream;
  Observable<String> get errorUsername => _errorUsername.stream;
  Observable<String> get errorPassword => _errorPassword.stream;

  void processLogin(context, String username, String password) {
    _isLoading.sink.add(true);
    bool flag = false;

    if (username == null || username.length == 0) {
      flag = true;
      _errorUsername.sink.add("Username can not null");
    }

    if (password == null || password.length == 0) {
      flag = true;
      _errorPassword.sink.add("Password can not null");
    }

    if (flag) {
      _isLoading.sink.add(false);
    } else {
      login(context, username, password);
    }
  }

  void login(context, String username, String password) async {
    Response response = await _authRepository.login(username, password);
    print(response.statusCode);
    switch (response.statusCode) {
      case 401:
        var result = "Incorrect Username or Password";
        _loginResult.sink.add(result);
        break;
      case 500:
        var result = "Operation failed";
        _loginResult.sink.add(result);
        break;
      case 200:
        var result = Account.fromJSON(json.decode(response.body));
        authBloc.openSession(result);
        _loginResult.sink.add(null);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (result.role == AccountConstant.ROLE_ACTOR) {
                return ScreenRoute.ACTOR_HOME;
              } else if (result.role == AccountConstant.ROLE_DIRECTOR) {
                return ScreenRoute.DIRECTOR_HOME;
              } else {
                return ScreenRoute.LOGIN_SRC;
              }
            },
          ),
        );
        break;
      default:
        var result = "Unknown error";
        _loginResult.sink.add(result);
    }

    _isLoading.sink.add(false);
  }

  void dispose() {
    _errorPassword.close();
    _errorUsername.close();
    _isLoading.close();
    _loginResult.close();
  }
}
