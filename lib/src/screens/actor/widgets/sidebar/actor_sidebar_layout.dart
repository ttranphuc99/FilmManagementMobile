import 'package:film_management/src/blocs/actor_navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'actor_sidebar.dart';

class ActorSideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ActorNavigationBloc(),
        child: Stack(
          children: <Widget>[
            BlocBuilder<ActorNavigationBloc, ActorNavigationStates>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            ActorSideBar(),
          ],
        ),
      ),
    );
  }
}
