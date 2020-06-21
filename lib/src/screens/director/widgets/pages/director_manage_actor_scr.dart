import 'package:film_management/src/blocs/director/manage_actor/list_actor_bloc.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/constants/env_variable.dart';
import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/screens/director/widgets/pages/director_actor_detail_scr.dart';
import 'package:film_management/src/screens/director/widgets/sidebar/director_sidebar_layout.dart';
import 'package:flutter/material.dart';

class DirectorManageActorScr extends StatefulWidget {
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
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
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
                      listWidget
                          .add(this._buildAccountRecord(account, context));
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
      ),
    );
  }

  Widget _buildAccountRecord(Account account, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: account.status ? Color(0xFFE6EE9C) : Color(0xFFFFCCBC),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      height: 110,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print("tap to see detail of " + account.username);
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => DirectorSideBarLayout(screen: DirectorActorDetailScr(actorId: account.id,),)
              ),
            );
        },
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  width: 70,
                  height: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 70,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(account.image != null &&
                                    account.image.isNotEmpty
                                ? account.image
                                : DEFAULT_AVATAR),
                          ),
                        ),
                      ),
                      account.status ? Container(width: 0, height: 0,) : Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey.withOpacity(0.8),
                          child: Icon(Icons.lock, color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    account.fullname,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '@' + account.username,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    account.phone ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    account.email ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
