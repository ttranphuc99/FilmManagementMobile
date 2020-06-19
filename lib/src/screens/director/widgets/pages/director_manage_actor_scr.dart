import 'package:film_management/src/blocs/director_navigation_bloc.dart';
import 'package:flutter/material.dart';

class DirectorManageActorScr extends StatefulWidget with DirectorNavigationStates {
  @override
  _DirectorManageActorScrState createState() => _DirectorManageActorScrState();
}

class _DirectorManageActorScrState extends State<DirectorManageActorScr> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Manage actor",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
