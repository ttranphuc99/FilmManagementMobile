import 'package:film_management/src/blocs/director/manage_equipment/list_equipment_bloc.dart';
import 'package:film_management/src/blocs/director/manage_scenario/list_equipment_in_scenario_bloc.dart';
import 'package:film_management/src/models/equipment.dart';
import 'package:film_management/src/models/scenario_equipment.dart';
import 'package:flutter/material.dart';

class DirectorScenarioEquipmentScr extends StatefulWidget {
  final scenarioId;

  const DirectorScenarioEquipmentScr({Key key, this.scenarioId})
      : super(key: key);

  @override
  _DirectorScenarioEquipmentScrState createState() =>
      _DirectorScenarioEquipmentScrState(scenarioId);
}

class _DirectorScenarioEquipmentScrState
    extends State<DirectorScenarioEquipmentScr> {
  final scenarioId;

  _DirectorScenarioEquipmentScrState(this.scenarioId);

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
      height: 150,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          print("tap to see detail of ");
          _showDialogUpdate(equipScen);
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
                  width: 280,
                  child: Text(
                    equipScen.description,
                    style: TextStyle(
                      fontSize: 12,
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

  List<DropdownMenuItem<Equipment>> _buildAvailableEquipmentLst() {
    var tmpLst = List<Equipment>();

    for (var equip in listEquipment) {
      bool isNotIn = true;
      for (var equipInScene in listEquipmentInScence) {
        if (equipInScene.equipment.id == equip.id ||
            equipInScene.equipmentAvailable == 0) {
          isNotIn = false;
          break;
        }
      }

      if (isNotIn && equip.status) tmpLst.add(equip);
    }

    listEquipment = tmpLst;

    var listMenuItem = List<DropdownMenuItem<Equipment>>();

    for (var item in listEquipment) {
      listMenuItem.add(
        DropdownMenuItem(
          value: item,
          child: Column(
            children: [
              Text(item.name),
              Text("#" + item.id.toString()),
            ],
          ),
        ),
      );
    }

    return listMenuItem;
  }

  void _showDialogInsert() {
    final _formKey = GlobalKey<FormState>();
    final _descriptionController = TextEditingController();
    final _quantityController = TextEditingController();

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
                            "Equipment",
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
                          hint: Text("Choose equipment"),
                          value: currentEquipmentChoose,
                          items: this._buildAvailableEquipmentLst(),
                          onChanged: (value) {
                            print(value.name);
                            setState(() {
                              currentEquipmentChoose = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          cursorColor: Color(0xFF00C853),
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: "Description",
                          ),
                        ),
                        TextFormField(
                          cursorColor: Color(0xFF00C853),
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Quantity",
                          ),
                          validator: (value) {
                            return this.validateQuantity;
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
                  onPressed: () async {
                    if (this.currentEquipmentChoose == null) {
                      this.setState(() {
                        this.validateQuantity = "Choose equipment first";
                      });
                    } else {
                      await this._validateQuantity(_quantityController.text,
                          this.currentEquipmentChoose.id);
                    }

                    if (_formKey.currentState.validate() &&
                        currentEquipmentChoose != null &&
                        validateQuantity == null) {
                      if (currentEquipmentChoose != null) {
                        ScenarioEquipment scenEquip = ScenarioEquipment();

                        scenEquip.description = _descriptionController.text;
                        scenEquip.quantity =
                            num.parse(_quantityController.text);

                        this._showProcessingDialog();
                        _bloc
                            .insertEquipment(this.scenarioId,
                                this.currentEquipmentChoose.id, scenEquip)
                            .then((value) async {
                          Navigator.of(context).pop();
                          if (value) {
                            Navigator.of(context).pop();
                            this.listEquipmentInScence =
                                await _bloc.getList(scenarioId);
                            this.currentEquipmentChoose = null;
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

  void _showDialogUpdate(ScenarioEquipment scenEquip) {
    final _formKey = GlobalKey<FormState>();
    final _descriptionController = TextEditingController();
    final _quantityController = TextEditingController();

    _descriptionController.text = scenEquip.description;
    _quantityController.text = scenEquip.quantity.toString();

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
                            "Equipment",
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
                            scenEquip.equipment.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "#" + scenEquip.equipment.id.toString(),
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
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: "Description",
                          ),
                        ),
                        TextFormField(
                          cursorColor: Color(0xFF00C853),
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Quantity",
                          ),
                          validator: (value) {
                            return this.validateQuantity;
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
                    this._showDialogConfirmDelete(scenEquip.equipment.id);
                  },
                ),
                new FlatButton(
                  child: new Text("Update"),
                  onPressed: () async {
                    await this._validateQuantity(
                        _quantityController.text, scenEquip.equipment.id);

                    if (_formKey.currentState.validate() &&
                        validateQuantity == null) {
                      if (scenEquip.description !=
                              _descriptionController.text.trim() ||
                          scenEquip.quantity !=
                              num.parse(_quantityController.text)) {
                        ScenarioEquipment newScenEquip = ScenarioEquipment();

                        newScenEquip.quantity =
                            num.parse(_quantityController.text);
                        newScenEquip.description = _descriptionController.text;

                        this._showProcessingDialog();

                        _bloc
                            .updateEquipment(this.scenarioId,
                                scenEquip.equipment.id, newScenEquip)
                            .then((value) async {
                          Navigator.of(context).pop();
                          if (value) {
                            Navigator.of(context).pop();
                            this.listEquipmentInScence =
                                await _bloc.getList(scenarioId);
                            this.currentEquipmentChoose = null;
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

  void _showDialogConfirmDelete(num equipId) {
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
                _bloc
                    .deleteEquipment(this.scenarioId, equipId)
                    .then((value) async {
                  Navigator.of(context).pop();
                  if (value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    this.listEquipmentInScence =
                        await _bloc.getList(scenarioId);
                    this.currentEquipmentChoose = null;
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  _validateQuantity(value, equipId) async {
    if (value.trim().isEmpty) {
      this.setState(() {
        this.validateQuantity = "Quantity is required";
      });
      return;
    } else if (num.parse(value) <= 0) {
      this.setState(() {
        this.validateQuantity = "Quantity is greater than 0";
      });
      return;
    } else {
      await _bloc
          .getAvailableQuantity(this.scenarioId, equipId)
          .then((available) {
        if (available == -1) {
          this.setState(() {
            this.validateQuantity = "Invalid data";
          });
          return;
        } else {
          if (available < num.parse(value)) {
            this.setState(() {
              this.validateQuantity =
                  "Current equipment available quantity is " +
                      available.toString();
            });
            return;
          } else {
            this.setState(() {
              this.validateQuantity = null;
            });
            return;
          }
        }
      });
    }
  }
}
