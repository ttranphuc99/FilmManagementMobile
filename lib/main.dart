import 'package:film_management/src/constants/constant.dart';
import 'package:film_management/src/screens/actor/widgets/sidebar/actor_sidebar_layout.dart';
import 'package:film_management/src/screens/director/widgets/sidebar/director_sidebar_layout.dart';
import 'package:flutter/material.dart';

import 'package:film_management/src/screens/guest/login_screen.dart';

import 'package:film_management/src/blocs/authentication_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc().restoreSession(AccountConstant.UNAUTHORIZE);

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF00C853),
      ),
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            createContent(),
          ],
        ),
      ),
    );
  }

  Widget createContent() {
    return StreamBuilder<bool>(
      stream: authBloc.isSessionValid,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && !snapshot.data) {
          return LoginScreen();
        }
        return StreamBuilder<int>(
          stream: authBloc.currentRole,
          builder: (context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == AccountConstant.ROLE_DIRECTOR) {
                return DirectorSideBarLayout();
              }
              return ActorSideBarLayout();
            }
            return LoginScreen();
          },
        );
      },
    );
  }
}
