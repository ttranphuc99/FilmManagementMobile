import 'package:film_management/src/blocs/director/manage_actor/list_actor_bloc.dart';
import 'package:film_management/src/blocs/director/manage_scenario/list_actor_in_scenario_bloc.dart';
import 'package:film_management/src/constants/env_variable.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/models/scenario_actor.dart';
import 'package:flutter/material.dart';

class DirectorScenarioActorScr extends StatefulWidget {
  final scenarioId;

  const DirectorScenarioActorScr({Key key, this.scenarioId}) : super(key: key);

  @override
  _DirectorScenarioActorScrState createState() =>
      _DirectorScenarioActorScrState(scenarioId);
}

class _DirectorScenarioActorScrState extends State<DirectorScenarioActorScr> {
  final scenarioId;

  _DirectorScenarioActorScrState(this.scenarioId);

  ListActorInScenarioBloc _bloc;
  ListActorBloc _actorBloc;
  List<Account> listActor;
  List<ScenarioActor> listActorInScence;
  Account currentActorChoose;

  @override
  void initState() {
    super.initState();

    _actorBloc = ListActorBloc(context);
    _actorBloc.loadData().then((value) {
      listActor = value;
    });

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
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Container(
            padding: EdgeInsets.all(20),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Color(0xFF00C853),
              onPressed: () {
                print('btnAdd Clicked');
                _showDialogInsert();
              },
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
          _showDialogUpdate(account);
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
                                fit: BoxFit.fill,
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

  List<DropdownMenuItem<Account>> _buildAvailableActorLst() {
    var tmpLst = List<Account>();

    for (var actor in listActor) {
      bool isNotIn = true;
      for (var actorInScene in listActorInScence) {
        if (actorInScene.actor.id == actor.id) {
          isNotIn = false;
          break;
        }
      }

      if (isNotIn && actor.status) tmpLst.add(actor);
    }

    listActor = tmpLst;

    var listMenuItem = List<DropdownMenuItem<Account>>();

    for (var item in listActor) {
      listMenuItem.add(
        DropdownMenuItem(
          value: item,
          child: Column(
            children: [
              Text(item.fullname),
              Text("@" + item.username),
            ],
          ),
        ),
      );
    }

    return listMenuItem;
  }

  void _showDialogInsert() {
    final _formKey = GlobalKey<FormState>();
    final _characterController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Container(
                alignment: Alignment.center,
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Color(0xFF00C853),
                  ),
                ),
              ),
              content: Container(
                child: Form(
                  key: _formKey,
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Color(0xFF00C853),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Actor",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00C853),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        DropdownButton(
                          hint: Text("Choose actor"),
                          value: currentActorChoose,
                          items: this._buildAvailableActorLst(),
                          onChanged: (value) {
                            print(value.username);
                            setState(() {
                              currentActorChoose = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          cursorColor: Color(0xFF00C853),
                          controller: _characterController,
                          decoration: InputDecoration(
                            labelText: "Chacracters",
                          ),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return "Character is required";
                            } else if (value.length > 20) {
                              return "Maximum length is 20 characters";
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Add"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      if (currentActorChoose != null) {
                        ScenarioActor scenAc = ScenarioActor();
                        scenAc.character = _characterController.text;
                        this._showProcessingDialog();
                        _bloc
                            .insert(this.scenarioId, this.currentActorChoose.id,
                                scenAc)
                            .then((value) async {
                          Navigator.of(context).pop();
                          if (value) {
                            Navigator.of(context).pop();
                            this.listActorInScence =
                                await _bloc.loadData(scenarioId);
                            this.currentActorChoose = null;
                          }
                        });
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDialogUpdate(ScenarioActor account) {
    final _formKey = GlobalKey<FormState>();
    final _characterController = TextEditingController();
    _characterController.text = account.character;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Container(
                alignment: Alignment.center,
                child: Text(
                  "Update",
                  style: TextStyle(
                    color: Color(0xFF00C853),
                  ),
                ),
              ),
              content: Container(
                child: Form(
                  key: _formKey,
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Color(0xFF00C853),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Actor",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00C853),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            account.actor.fullname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "@" + account.actor.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          cursorColor: Color(0xFF00C853),
                          controller: _characterController,
                          decoration: InputDecoration(
                            labelText: "Chacracters",
                          ),
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return "Character is required";
                            } else if (value.length > 20) {
                              return "Maximum length is 20 characters";
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Remove"),
                  onPressed: () {
                    this._showDialogConfirmDelete(account.actor.id);
                  },
                ),
                new FlatButton(
                  child: new Text("Update"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      if (account.character !=
                          _characterController.text.trim()) {
                        ScenarioActor scenAc = ScenarioActor();
                        scenAc.character = _characterController.text;
                        this._showProcessingDialog();
                        _bloc
                            .update(this.scenarioId, account.actor.id,
                                scenAc)
                            .then((value) async {
                          Navigator.of(context).pop();
                          if (value) {
                            Navigator.of(context).pop();                            
                            this.listActorInScence =
                                await _bloc.loadData(scenarioId);
                            this.currentActorChoose = null;
                          }
                        });
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showProcessingDialog() {
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Processing"),
          content: Container(
            height: 80,
            child: Center(
              child: Column(children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please Wait....",
                  style: TextStyle(color: Colors.blueAccent),
                )
              ]),
            ),
          ),
        );
      },
    );
  }

  void _showDialogConfirmDelete(num actorId) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm Remove"),
          content: new Text("Do you want to remove"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                this._showProcessingDialog();
                _bloc.delete(this.scenarioId, actorId).then((value) async {
                  Navigator.of(context).pop();
                  if (value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    this.listActorInScence = await _bloc.loadData(scenarioId);
                    this.currentActorChoose = null;
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }
}
