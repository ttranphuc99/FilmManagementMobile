import 'package:film_management/src/blocs/authentication_bloc.dart';
import 'package:film_management/src/constants/screen_routes.dart';
import 'package:film_management/src/repositories/authenticate_repo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

class LogoutBloc {
  final AuthRepository _authRepository = AuthRepository();

  final PublishSubject<bool> _isLoading = PublishSubject<bool>();

  Observable<bool> get isLoading => _isLoading.stream;

  void dispose() {
    _isLoading.close();
  }

  void processLogout(context) async {
    _isLoading.sink.add(true);

    try {
      var authBloc = AuthenticationBloc();
      var account = await authBloc.getProfile();

      Response response = await _authRepository.logout(account.token);
      print('there');
      print(response.statusCode);
      switch (response.statusCode) {
        case 200:
          print('out');
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ScreenRoute.LOGIN_SRC), (route) => false);
          authBloc.closeSession();
          break;
        case 500:
          _showSnackbar(context, "Server process failed!");
          break;
      }

      _isLoading.sink.add(false);
    } catch (e) {
      print(e);
      _showSnackbar(context, "App processing failed!");
      _isLoading.sink.add(false);
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    Scaffold.of(context).hideCurrentSnackBar();

    if (message != null && message.trim().length > 0) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }
}