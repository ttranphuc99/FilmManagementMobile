import 'package:film_management/src/screens/actor/widgets/pages/actor_dashboard_scr.dart';
import 'package:flutter/material.dart';

import 'actor_sidebar.dart';

class ActorSideBarLayout extends StatelessWidget {
  final Widget screen;

  const ActorSideBarLayout({Key key, this.screen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          screen ?? ActorDashboardScr(),
          ActorSideBar()
        ],
      )
    );
  }
}
