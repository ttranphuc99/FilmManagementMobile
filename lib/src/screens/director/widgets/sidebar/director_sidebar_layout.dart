import 'package:film_management/src/screens/director/widgets/pages/director_dashboard_scr.dart';
import 'package:flutter/material.dart';
import 'director_sidebar.dart';

class DirectorSideBarLayout extends StatelessWidget {
  final Widget screen;

  const DirectorSideBarLayout({Key key, this.screen}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
            screen ?? DirectorDashboardScr(),
            DirectorSideBar(),
          ],
        ),
    );
  }
}
