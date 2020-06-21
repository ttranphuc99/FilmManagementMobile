import 'package:film_management/src/blocs/director/director_navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'director_sidebar.dart';

class DirectorSideBarLayout extends StatelessWidget {
  final Widget screen;

  const DirectorSideBarLayout({Key key, this.screen}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => DirectorNavigationBloc(),
        child: Stack(
          children: <Widget>[
            screen,
            DirectorSideBar(),
          ],
        ),
      ),
    );
  }
}
