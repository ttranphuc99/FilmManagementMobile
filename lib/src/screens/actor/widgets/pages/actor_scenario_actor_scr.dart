import 'package:film_management/src/blocs/director/manage_scenario/list_actor_in_scenario_bloc.dart';
import 'package:film_management/src/constants/env_variable.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/models/scenario_actor.dart';
import 'package:flutter/material.dart';

class ActorScenarioActorScr extends StatefulWidget {
  final scenarioId;

  const ActorScenarioActorScr({Key key, this.scenarioId}) : super(key: key);

  @override
  _ActorScenarioActorScrState createState() =>
      _ActorScenarioActorScrState(scenarioId);
}

class _ActorScenarioActorScrState extends State<ActorScenarioActorScr> {
  final scenarioId;

  _ActorScenarioActorScrState(this.scenarioId);

  ListActorInScenarioBloc _bloc;
  List<Account> listActor;
  List<ScenarioActor> listActorInScence;
  Account currentActorChoose;

  @override
  void initState() {
    super.initState();

    _bloc = ListActorInScenarioBloc(context);
    _bloc.loadData(scenarioId).then((value) => listActorInScence = value);
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
                      stream: _bloc.listAcrtors,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var list = snapshot.data as List<ScenarioActor>;
                          var result = <Widget>[];

                          for (var item in list) {
                            result.add(this._buildAccountRecord(item, context));
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
          "Actors",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
        ),
      ),
    );
  }

  Widget _buildAccountRecord(ScenarioActor account, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFE6EE9C),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      height: 200,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
        },
        child: Column(
          children: [
            Row(
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
                                fit: BoxFit.fitWidth,
                                image: new NetworkImage(
                                    account.actor.image != null &&
                                            account.actor.image.isNotEmpty
                                        ? account.actor.image
                                        : DEFAULT_AVATAR),
                              ),
                            ),
                          ),
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
                        account.actor.fullname,
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
                        '@' + account.actor.username,
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
                        account.actor.phone ?? "",
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
                        account.actor.email ?? "",
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
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: 250,
                      child: Text(
                        account.character ?? "",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF212121),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: 250,
                      child: Text(
                        account.lastModified != null
                            ? "Last Modified:"
                            : "Created Time:",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: 250,
                      child: Text(
                        account.lastModified != null
                            ? (account.lastModified.substring(0, 10) +
                                " " +
                                account.lastModified.substring(11, 19))
                            : (account.createdTime.substring(0, 10) +
                                " " +
                                account.createdTime.substring(11, 19)),
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
