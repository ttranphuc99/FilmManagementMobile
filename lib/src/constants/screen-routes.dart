import 'package:film_management/src/screens/actor/actor_home.dart';
import 'package:film_management/src/screens/director/director_home.dart';
import 'package:film_management/src/screens/guest/login_screen.dart';
import 'package:flutter/material.dart';

class ScreenRoute {
  static final StatefulWidget LOGIN_SRC = LoginScreen();

  static final StatefulWidget ACTOR_HOME = ActorHomeScreen();

  static final StatefulWidget DIRECTOR_HOME = DirectorHomeScreen();
}