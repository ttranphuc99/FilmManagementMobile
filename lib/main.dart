import 'package:flutter/material.dart';

import 'package:film_management/src/screens/guest/login_screen.dart';

import 'package:film_management/src/blocs/authentication_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: createContent(),
      ),
    );
  }

  Widget createContent() {
    return StreamBuilder<bool>(
      stream: authBloc.isSessionValid,
      builder: (context, AsyncSnapshot<bool> snapshoot) {
        if (snapshoot.hasData && snapshoot.data) {
          return LoginScreen();
        }
        return LoginScreen();
      },
    );
  }
}
