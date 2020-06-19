import 'package:film_management/src/blocs/director_navigation_bloc.dart';
import 'package:flutter/material.dart';

class DirectorDashboardScr extends StatelessWidget with DirectorNavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "HomePage of Director",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
