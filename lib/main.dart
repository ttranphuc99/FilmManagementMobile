import 'package:film_management/src/constants/constant.dart';
import 'package:film_management/src/screens/widgets/sidebar/sidebar_layout.dart';
import 'package:flutter/material.dart';

import 'package:film_management/src/screens/guest/login_screen.dart';

import 'package:film_management/src/blocs/authentication_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc().restoreSession(AccountConstant.UNAUTHORIZE);

    return MaterialApp(
      home: Scaffold(
        body: createContent(),
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
          builder: (context, AsyncSnapshot<int> snapshot){
            if (snapshot.hasData) {
              if (snapshot.data == AccountConstant.ROLE_DIRECTOR) {
                return SideBarLayout();
              }
              return SideBarLayout();
            }
            return LoginScreen();
          },
        );
      },
    );
  }
}
