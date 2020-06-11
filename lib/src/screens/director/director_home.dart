import 'package:flutter/material.dart';

import 'package:film_management/src/blocs/authentication_bloc.dart';

import 'package:film_management/src/constants/constant.dart';

class DirectorHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DirectorHomeState();
  }
}

class _DirectorHomeState extends State {
  @override
  Widget build(BuildContext context) {
    authBloc.restoreSession(AccountConstant.ROLE_DIRECTOR);
    return Scaffold(
      body: Text("Hello from director"),
    );
  }
}