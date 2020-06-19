import 'package:film_management/src/blocs/director/director_navigation_bloc.dart';
import 'package:film_management/src/blocs/director/manage_actor/list_actor_bloc.dart';
import 'package:film_management/src/models/account.dart';
import 'package:flutter/material.dart';

class DirectorManageActorScr extends StatefulWidget
    with DirectorNavigationStates {
  @override
  _DirectorManageActorScrState createState() => _DirectorManageActorScrState();
}

class _DirectorManageActorScrState extends State<DirectorManageActorScr> {
  ListActorBloc _listActorBloc;

  @override
  Widget build(BuildContext context) {
    _listActorBloc = ListActorBloc(context);
    _listActorBloc.loadData();

    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Manage actor",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
            ),
            StreamBuilder(
              stream: _listActorBloc.listAccount,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var listWidget = <Widget>[];

                  snapshot.data.forEach((account) {
                    listWidget.add(this._buildAccountRecord(account));
                  });

                  return Column(
                    children: listWidget,
                  );
                }
                return Text("no data yet");
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAccountRecord(Account account) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 25),
        Container(
          alignment: Alignment.centerLeft,
          height: 60,
          child: Text(account.username),
        )
      ],
    );
  }
}
