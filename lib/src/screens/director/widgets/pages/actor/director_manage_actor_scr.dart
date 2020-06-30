import 'package:film_management/src/blocs/director/manage_actor/list_actor_bloc.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/constants/env_variable.dart';
import 'package:film_management/src/screens/director/widgets/pages/actor/director_add_actor_scr.dart';
import 'package:film_management/src/screens/director/widgets/pages/actor/director_actor_detail_scr.dart';
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

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Manage actor",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 28),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                TextField(
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    _listActorBloc.searchByFullname(value);
                                  },
                                  style: TextStyle(
                                    color: Color(0xFF212121),
                                    fontFamily: 'OpenSans',
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFE6EE9C), width: 7.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFFFCCBC), width: 3.0),
                                    ),
                                    contentPadding: EdgeInsets.only(top: 14.0),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Color(0xFF212121),
                                    ),
                                    hintText: 'Search by fullname...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF212121),
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: _listActorBloc.listAccount,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var listWidget = <Widget>[];

                            if (snapshot.data.isEmpty) {
                              return Text("Not found any actor!");
                            }
                            snapshot.data.forEach((account) {
                              listWidget.add(
                                  this._buildAccountRecord(account, context));
                            });

                            return Column(
                              children: listWidget,
                            );
                          }
                          return Text("Loading...");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Container(
              padding: EdgeInsets.all(20),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Color(0xFF00C853),
                onPressed: () {
                  print('btnAdd Clicked');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          DirectorSideBarLayout(screen: DirectorAddActorScr()),
                    ),
                  ).then((value) => _listActorBloc.loadData());
                },
              ),
            ),
          ),
        ],
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
                builder: (context) => DirectorSideBarLayout(
                      screen: DirectorActorDetailScr(
                        actorId: account.id,
                      ),
                    )),
          ).then((value) => _listActorBloc.loadData());
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
                      account.status
                          ? Container(
                              width: 0,
                              height: 0,
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.grey.withOpacity(0.8),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
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
