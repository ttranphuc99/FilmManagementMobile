import 'package:film_management/src/blocs/actor/actor_list_scenario_bloc.dart';
import 'package:film_management/src/models/scenario_actor.dart';
import 'package:film_management/src/screens/actor/widgets/pages/actor_scenario_info_scr.dart';
import 'package:film_management/src/screens/actor/widgets/sidebar/actor_sidebar_layout.dart';
import 'package:flutter/material.dart';

class ActorDashboardScr extends StatefulWidget {
  @override
  _ActorDashboardScrState createState() => _ActorDashboardScrState();
}

class _ActorDashboardScrState extends State<ActorDashboardScr> {
  ActorListScenarioBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ActorListScenarioBloc(context);
    _bloc.loadData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 32),
          child: Center(
            child: Column(
              children: [
                Text(
                  "List Scenarios",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
                ),
                StreamBuilder(
                  stream: _bloc.listScen,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        var listWidget = <Widget>[];

                        if (snapshot.data.isEmpty) {
                          return Text("Not found any scenario!");
                        }

                        snapshot.data.forEach((scenario) {
                          listWidget.add(this._buildScenarioRecord(scenario));
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
    );
  }

  Widget _buildScenarioRecord(ScenarioActor scenAc) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: scenAc.scenario.status != -1 ? Color(0xFFE6EE9C) : Color(0xFFFFCCBC),
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
          print("tap to see detail of " + scenAc.scenario.id.toString());
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ActorSideBarLayout(
                      screen: ActorScenarioInfoScr(
                        scenarioId: scenAc.scenario.id,
                      ),
                    )),
          ).then((value) => _bloc.loadData());
        },
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    scenAc.scenario.name,
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
                    '@ ' + scenAc.scenario.location,
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
                        scenAc.scenario.timeStart.substring(0, 10) +
                        "  " +
                        scenAc.scenario.timeStart.substring(11, 19),
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
                        scenAc.scenario.timeEnd.substring(0, 10) +
                        "  " +
                        scenAc.scenario.timeEnd.substring(11, 19),
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
                    "Status: " + this.getStatus(scenAc.scenario.status),
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
