import 'package:film_management/src/screens/actor/widgets/pages/actor_scenario_actor_scr.dart';
import 'package:film_management/src/screens/actor/widgets/pages/actor_scenario_detail_scr.dart';
import 'package:film_management/src/screens/actor/widgets/pages/actor_scenario_equipment_scr.dart';
import 'package:film_management/src/screens/director/widgets/pages/scenario/director_scenario_actor_scr.dart';
import 'package:film_management/src/screens/director/widgets/pages/scenario/director_scenario_detail_scr.dart';
import 'package:film_management/src/screens/director/widgets/pages/scenario/director_scenario_equipment_scr.dart';
import 'package:flutter/material.dart';

class ActorScenarioInfoScr extends StatefulWidget {
  final scenarioId;

  const ActorScenarioInfoScr({Key key, this.scenarioId}) : super(key: key);

  @override
  _ActorScenarioInfoScrState createState() =>
      _ActorScenarioInfoScrState(scenarioId);
}

class _ActorScenarioInfoScrState extends State<ActorScenarioInfoScr> {
  final scenarioId;

  _ActorScenarioInfoScrState(this.scenarioId);

  int tabIndex = 0;
  List<Widget> listScreens;

  @override
  void initState() {
    super.initState();
    listScreens = [
      ActorScenarioDetailScr(
        scenarioId: scenarioId,
      ),
      ActorScenarioEquipmentScr(
        scenarioId: scenarioId,
      ),
      ActorScenarioActorScr(
        scenarioId: scenarioId,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listScreens[tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: tabIndex,
        onTap: (int index) {
          this.setState(() {
            tabIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            title: Text("Detail"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            title: Text("Equipments"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            title: Text("Actors"),
          )
        ],
      ),
    );
  }
}
