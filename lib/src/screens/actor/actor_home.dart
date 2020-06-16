import 'package:film_management/src/blocs/authentication_bloc.dart';
import 'package:film_management/src/constants/constant.dart';
import 'package:film_management/src/screens/widgets/sidebar/sidebar_layout.dart';
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
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white
      ),
      home: SideBarLayout(),
    );
  }
}