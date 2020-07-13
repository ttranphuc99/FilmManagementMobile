import 'package:film_management/src/blocs/director/manage_equipment/list_equipment_bloc.dart';
import 'package:film_management/src/blocs/director/manage_scenario/list_equipment_in_scenario_bloc.dart';
import 'package:film_management/src/models/equipment.dart';
import 'package:film_management/src/models/scenario_equipment.dart';
import 'package:flutter/material.dart';

class ActorScenarioEquipmentScr extends StatefulWidget {
  final scenarioId;

  const ActorScenarioEquipmentScr({Key key, this.scenarioId})
      : super(key: key);

  @override
  _ActorScenarioEquipmentScrState createState() =>
      _ActorScenarioEquipmentScrState(scenarioId);
}

class _ActorScenarioEquipmentScrState
    extends State<ActorScenarioEquipmentScr> {
  final scenarioId;

  _ActorScenarioEquipmentScrState(this.scenarioId);

  ListEquipmentInScenarioBloc _bloc;
  ListEquipmentBloc _equipmentBloc;
  List<Equipment> listEquipment;
  List<ScenarioEquipment> listEquipmentInScence;
  Equipment currentEquipmentChoose;
  String validateQuantity;

  @override
  void initState() {
    super.initState();

    _equipmentBloc = ListEquipmentBloc(context);
    _equipmentBloc.getList().then((value) {
      listEquipment = value;
    });

    _bloc = ListEquipmentInScenarioBloc(context);
    _bloc.getList(scenarioId).then((value) => listEquipmentInScence = value);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    _buildTitle(),
                    StreamBuilder(
                      stream: _bloc.listEquipment,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var list = snapshot.data as List<ScenarioEquipment>;
                          var result = <Widget>[];

                          for (var item in list) {
                            result
                                .add(this._buildEquipmentRecord(item, context));
                          }

                          return Column(
                            children: result,
                          );
                        }

                        return Text("Loading ...");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Container(
        child: Text(
          "Equipments",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
        ),
      ),
    );
  }

  Widget _buildEquipmentRecord(
      ScenarioEquipment equipScen, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: equipScen.equipmentAvailable >= equipScen.quantity
            ? Color(0xFFE6EE9C)
            : Color(0xFFFFCCBC),
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
        },
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    equipScen.equipment.name,
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
                    'Quantity: ' + equipScen.quantity.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    equipScen.lastModified != null
                        ? 'Last Modified: '
                        : 'Created Time',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    equipScen.lastModified != null
                        ? (equipScen.lastModified.substring(0, 10) +
                            " " +
                            equipScen.lastModified.substring(11, 19))
                        : (equipScen.createdTime.substring(0, 10) +
                            " " +
                            equipScen.createdTime.substring(11, 19)),
                    style: TextStyle(
                      fontSize: 13,
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
