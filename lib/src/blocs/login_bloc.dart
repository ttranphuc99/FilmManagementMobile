import 'package:film_management/src/blocs/authentication_bloc.dart';
import 'package:film_management/src/repositories/authenticate_repo.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/constants/screen_routes.dart';
import 'package:film_management/src/constants/constant.dart';
import 'package:film_management/src/providers/firebase_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

class LoginBloc {
  final AuthRepository _authRepository = AuthRepository();

  final PublishSubject<bool> _isLoading = PublishSubject<bool>();
  final PublishSubject<String> _loginResult = PublishSubject<String>();

  Stream<bool> get isLoading => _isLoading.stream;
  Stream<String> get loginResult => _loginResult.stream;

  void processLogin(context, String username, String password) {
    _isLoading.sink.add(true);
    bool flag = false;

    if (username == null || username.length == 0) {
      flag = true;
      _showToast(context, "Username cannot be empty");
      return;
    }

    if (password == null || password.length == 0) {
      flag = true;
      _showToast(context, "Password cannot be empty");
      return;
    }

    if (flag) {
      _isLoading.sink.add(false);
    } else {
      login(context, username, password);
    }
  }

  void _showToast(BuildContext context, String message) {
    Scaffold.of(context).hideCurrentSnackBar();

    if (message != null && message.trim().length > 0) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  void login(context, String username, String password) async {
    _loginResult.sink.add("");
    try {
      String deviceToken =
          await FirebaseProvider().getDeviceToken().then((value) => value);

      Response response =
          await _authRepository.login(username, password, deviceToken);
      print(response.statusCode);
      _isLoading.sink.add(false);
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                ScreenRoute.hideNotificationBar();
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
    } catch (e) {
      _loginResult.sink.add("Processing Error Occur");
      _isLoading.sink.add(false);
      print(e);
    }
  }

  void dispose() {
    _isLoading.close();
    _loginResult.close();
  }
}
