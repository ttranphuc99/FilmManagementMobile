import 'package:film_management/src/blocs/director/director_navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'director_sidebar.dart';

class DirectorSideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => DirectorNavigationBloc(),
        child: Stack(
          children: <Widget>[
            BlocBuilder<DirectorNavigationBloc, DirectorNavigationStates>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            DirectorSideBar(),
          ],
        ),
      ),
    );
  }
}
