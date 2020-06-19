import 'package:film_management/src/blocs/actor/actor_navigation_bloc.dart';
import 'package:flutter/material.dart';

class ActorScr extends StatelessWidget with ActorNavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "My Accounts",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
