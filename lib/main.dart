import 'package:film_management/src/constants/constant.dart';
import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/screens/actor/widgets/sidebar/actor_sidebar_layout.dart';
import 'package:film_management/src/screens/director/widgets/sidebar/director_sidebar_layout.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  final FirebaseMessaging _firebaseMess = FirebaseMessaging();
  Map<String, dynamic> noti;

  @override
  void initState() {
    super.initState();
    _firebaseMess.configure(
      onMessage: (Map<String, dynamic> message) async {
      },
      onLaunch: (message) async {},
      onResume: (message) async {},
    );
  }

  void _showProcessingDialog() {
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Processing"),
          content: Container(
            height: 80,
            child: Center(
              child: Column(children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please Wait....",
                  style: TextStyle(color: Colors.blueAccent),
                )
              ]),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc().restoreSession(AccountConstant.UNAUTHORIZE);
    print('build ' + (noti == null).toString());
    if (noti != null) this._showProcessingDialog();

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF00C853),
      ),
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
