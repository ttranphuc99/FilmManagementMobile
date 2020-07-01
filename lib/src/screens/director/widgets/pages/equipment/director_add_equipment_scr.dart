import 'package:film_management/src/blocs/director/manage_equipment/add_equipment_bloc.dart';
import 'package:film_management/src/models/equipment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DirectorAddEquipmentScr extends StatefulWidget {
  @override
  _DirectorAddEquipmentScrState createState() => _DirectorAddEquipmentScrState();
}

class _DirectorAddEquipmentScrState extends State<DirectorAddEquipmentScr> {
  AddEquipmentBloc _addBloc;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _addBloc = AddEquipmentBloc(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 32),
            child: Center(
              child: Column(
                children: [
                  _buildTitle(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Container(
        child: Text(
          "Add new Equipment",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Theme(
        data: ThemeData(
          primaryColor: Color(0xFF00C853),
        ),
        child: Column(
          children: [
            TextFormField(
              cursorColor: Color(0xFF00C853),
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
              ),
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
                if (int.parse(value) < 0) {
                  return "Quantity cannot < 0";
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            Container(
              child: ButtonTheme(
                buttonColor: Color(0xFF00C853),
                child: RaisedButton(
                  child: Text(
                    "ADD",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Equipment equipment = Equipment.emptyEquipment();
                    equipment.name = _nameController.text;
                    equipment.description = _descriptionController.text;

                    var quantity = _quantityController.text != null &&
                            _quantityController.text.trim().isNotEmpty
                        ? _quantityController.text
                        : "0";

                    equipment.quantity = int.parse(quantity);

                    this._showProcessingDialog();
                    _addBloc.insert(equipment).then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
}
