import 'package:file_picker/file_picker.dart';
import 'package:film_management/src/blocs/director/manage_scenario/add_scenario_bloc.dart';
import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/my_file.dart';
import 'package:film_management/src/models/scenario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DirectorAddScenarioScr extends StatefulWidget {
  @override
  _DirectorAddScenarioScrState createState() => _DirectorAddScenarioScrState();
}

class _DirectorAddScenarioScrState extends State<DirectorAddScenarioScr> {
  AddScenarioBloc _addBloc;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _recordQuantityController = TextEditingController();

  String timeStart;
  String timeEnd;
  MyFile script;

  @override
  void initState() {
    super.initState();
    timeStart = DateTime.now().toString().substring(0, 16);
    timeEnd = timeStart;
    script = MyFile();
  }

  @override
  Widget build(BuildContext context) {
    _addBloc = AddScenarioBloc(context);

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
          "Add new Scenario",
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
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Location",
              ),
            ),
            TextFormField(
              cursorColor: Color(0xFF00C853),
              controller: _recordQuantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Record Quantity",
              ),
              validator: (value) {
                if (int.parse(value) < 0) {
                  return "Record quantity cannot < 0";
                }
                return null;
              },
            ),
            ListTile(
              title: Text("Time start:"),
              subtitle: Text(
                  timeStart.substring(0, 10) + " " + timeStart.substring(11)),
              trailing: Icon(
                Icons.calendar_today,
                color: Color(0xFF00C853),
              ),
              onTap: () {
                _pickDateTime(timeStart).then((value) => this.setState(() {
                      timeStart = value;
                    }));
              },
            ),
            ListTile(
              title: Text("Time end:"),
              subtitle:
                  Text(timeEnd.substring(0, 10) + " " + timeEnd.substring(11)),
              trailing: Icon(
                Icons.calendar_today,
                color: Color(0xFF00C853),
              ),
              onTap: () {
                _pickDateTime(timeEnd).then((value) => this.setState(() {
                      timeEnd = value;
                    }));
              },
            ),
            ListTile(
              title: Text("Script:"),
              subtitle: Text(script.filename ?? "Click to choose file"),
              trailing: Icon(
                Icons.file_upload,
                color: Color(0xFF00C853),
              ),
              onTap: () {
                FilePicker.getFile().then((file) {
                  var filename =
                      file.path.substring(file.path.lastIndexOf('/') + 1);
                  var extendsion =
                      filename.substring(filename.lastIndexOf('.') + 1);

                  if (extendsion != 'pdf' && extendsion != 'doc') {
                    MySnackbar.showSnackbar(
                        context, "File extension is not allow");
                    return;
                  }

                  setState(() {
                    script.filename = filename;
                    script.fileExtension = extendsion;
                    script.file = file;
                  });
                });
              },
            ),
            Container(
              height: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonTheme(
                    minWidth: 10,
                    buttonColor: Color(0xFF00C853),
                    child: RaisedButton(
                      child: Container(
                        child: Text(
                          "Discard this script",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        this.setState(() {
                          script.reset();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Divider(
              thickness: 2,
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
                    Scenario scenario = Scenario.emptyScenario();
                    scenario.name = _nameController.text;
                    scenario.description = _descriptionController.text;
                    scenario.location = _locationController.text;

                    var recordQuan = _recordQuantityController.text != null &&
                            _recordQuantityController.text.trim().isNotEmpty
                        ? _recordQuantityController.text
                        : "0";

                    scenario.recordQuantity = int.parse(recordQuan);
                    scenario.timeStart = timeStart;
                    scenario.timeEnd = timeEnd;

                    this._showProcessingDialog();
                    _addBloc.addScenario(scenario, script).then((value) {
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

  Future<String> _pickDateTime(String current) async {
    if (current.isEmpty) current = DateTime.now().toString();

    DateTime defaultDate = DateTime.parse(current);
    TimeOfDay defaultTime = TimeOfDay.fromDateTime(defaultDate);

    DateTime date = await showDatePicker(
      context: context,
      initialDate: defaultDate,
      firstDate: DateTime(defaultDate.year - 5),
      lastDate: DateTime(defaultDate.year + 5),
    );

    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: defaultTime,
    );

    String strDate = date.toString().substring(0, 11);
    String timeHour = time.toString().substring(10, 12);
    String timeMinute = time.toString().substring(13, 15);

    strDate = strDate + timeHour + ":" + timeMinute;
    return strDate;
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
