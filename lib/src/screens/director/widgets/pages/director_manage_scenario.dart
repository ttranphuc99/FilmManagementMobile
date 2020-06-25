import 'package:film_management/src/blocs/director/manage_scenario/list_scenario_bloc.dart';
import 'package:film_management/src/models/scenario.dart';
import 'package:film_management/src/screens/director/widgets/pages/director_add_scenario_scr.dart';
import 'package:film_management/src/screens/director/widgets/sidebar/director_sidebar_layout.dart';
import 'package:flutter/material.dart';

class DirectorManageScenario extends StatefulWidget {
  @override
  _DirectorManageScenarioState createState() => _DirectorManageScenarioState();
}

class _DirectorManageScenarioState extends State<DirectorManageScenario> {
  ListScenarioBloc _listScenarioBloc;

  @override
  Widget build(BuildContext context) {
    _listScenarioBloc = ListScenarioBloc(context);
    _listScenarioBloc.getListScenario();

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
                    children: [
                      Text(
                        "Manage Scenario",
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
                                    print(value);
                                    _listScenarioBloc.searchByName(value);
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
                                    hintText: 'Search by name of scenario...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF212121),
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: _listScenarioBloc.list,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null) {
                              var listWidget = <Widget>[];

                              if (snapshot.data.isEmpty) {
                                return Text("Not found any scenario!");
                              }

                              snapshot.data.forEach((scenario) {
                                listWidget
                                    .add(this._buildScenarioRecord(scenario));
                              });

                              return Column(
                                children: listWidget,
                              );
                            }
                            return Container(
                              height: 0,
                              width: 0,
                            );
                          }

                          return Text("Loading");
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
                          DirectorSideBarLayout(screen: DirectorAddScenarioScr()),
                    ),
                  ).then((value) => _listScenarioBloc.getListScenario());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioRecord(Scenario scenario) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: scenario.status != -1 ? Color(0xFFE6EE9C) : Color(0xFFFFCCBC),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      height: 170,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print("tap to see detail of " + scenario.id.toString());
          /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DirectorSideBarLayout(
                      screen: DirectorActorDetailScr(
                        actorId: account.id,
                      ),
                    )),
          ).then((value) => _listActorBloc.loadData());*/
        },
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    scenario.name,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '@ ' + scenario.location,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Start: " +
                        scenario.timeStart.substring(0, 10) +
                        "  " +
                        scenario.timeStart.substring(11),
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "End: " +
                        scenario.timeEnd.substring(0, 10) +
                        "  " +
                        scenario.timeEnd.substring(11),
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Status: " + this.getStatus(scenario.status),
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

  String getStatus(int status) {
    var result = "";
    switch (status) {
      case -1:
        return "Hủy";
      case 0:
        return "Đang chờ";
      case 1:
        return "Đang quay";
      case 2:
        return "Hoàn thành";
    }
    return result;
  }
}
