import 'package:film_management/src/screens/actor/widgets/sidebar/actor_sidebar_layout.dart';
import 'package:film_management/src/screens/director/widgets/sidebar/director_sidebar_layout.dart';
import 'package:film_management/src/screens/guest/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenRoute {
  static final Widget LOGIN_SRC = LoginScreen();

  static final Widget ACTOR_HOME = ActorSideBarLayout();

  static final Widget DIRECTOR_HOME = DirectorSideBarLayout();

  static void hideNotificationBar() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }
}