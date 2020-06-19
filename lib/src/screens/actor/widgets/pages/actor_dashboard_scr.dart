import 'package:film_management/src/blocs/actor_navigation_bloc.dart';
import 'package:flutter/material.dart';

class ActorDashboardScr extends StatelessWidget with ActorNavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Actor Dashboard",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
