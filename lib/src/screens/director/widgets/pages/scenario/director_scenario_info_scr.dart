import 'package:film_management/src/screens/director/widgets/pages/scenario/director_scenario_actor_scr.dart';
import 'package:film_management/src/screens/director/widgets/pages/scenario/director_scenario_detail_scr.dart';
import 'package:film_management/src/screens/director/widgets/pages/scenario/director_scenario_euipment_scr.dart';
import 'package:flutter/material.dart';

class DirectorScenarioInfoScr extends StatefulWidget {
  final scenarioId;

  const DirectorScenarioInfoScr({Key key, this.scenarioId}) : super(key: key);

  @override
  _DirectorScenarioInfoScrState createState() =>
      _DirectorScenarioInfoScrState(scenarioId);
}

class _DirectorScenarioInfoScrState extends State<DirectorScenarioInfoScr> {
  final scenarioId;

  _DirectorScenarioInfoScrState(this.scenarioId);

  int tabIndex = 0;
  List<Widget> listScreens;

  @override
  void initState() {
    super.initState();
    listScreens = [
      DirectorScenarioDetailScr(
        scenarioId: scenarioId,
      ),
      DirectorScenarioEquipmentScr(),
      DirectorScenarioActorScr()
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
