import 'package:film_management/src/blocs/authentication_bloc.dart';
import 'package:film_management/src/constants/constant.dart';
import 'package:flutter/material.dart';

class ActorHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ActorHomeState();
  }
}

class _ActorHomeState extends State {
  @override
  Widget build(BuildContext context) {
    authBloc.restoreSession(AccountConstant.ROLE_ACTOR);
    return Scaffold(
      body: Text("Hello from actor"),
    );
  }
}