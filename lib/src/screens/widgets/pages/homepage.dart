import 'package:film_management/src/blocs/navigation_bloc.dart';
import 'package:film_management/src/constants/screen_routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      /*child: Text(
        "HomePage",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),*/
      child: RaisedButton(onPressed: () {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ScreenRoute.LOGIN_SRC), (route) => false);
      })
    );
  }
}
