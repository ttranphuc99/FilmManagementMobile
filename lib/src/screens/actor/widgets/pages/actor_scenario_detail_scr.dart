import 'package:file_picker/file_picker.dart';
import 'package:film_management/src/blocs/director/manage_scenario/scenario_detail_bloc.dart';
import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/my_file.dart';
import 'package:film_management/src/models/scenario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ActorScenarioDetailScr extends StatefulWidget {
  final scenarioId;

  const ActorScenarioDetailScr({Key key, this.scenarioId}) : super(key: key);

  @override
  _ActorScenarioDetailScrState createState() =>
      _ActorScenarioDetailScrState(scenarioId);
}

class _ActorScenarioDetailScrState extends State<ActorScenarioDetailScr> {
  ScenarioDetailBloc _detailBloc;
  final scenarioId;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _recordQuantityController = TextEditingController();

  String timeStart;
  String timeEnd;
  MyFile script;
  Scenario scenarioData;
  int status;
  bool fileChanged;
  bool isLoading;

  _ActorScenarioDetailScrState(this.scenarioId);

  @override
  void initState() {
    super.initState();
    timeStart = DateTime.now().toString().substring(0, 16);
    timeEnd = timeStart;
    status = 0;
    fileChanged = false;
    script = MyFile();
    isLoading = true;
    this.loadData();
  }

  @override
  Widget build(BuildContext context) {
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
          "Scenario Detail",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
        ),
      ),
    );
  }

  Widget _buildForm() {
    if (isLoading) {
      return Text('Loading...');
    }
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
              validator: (value) {
                if (value.trim().isEmpty) {
                  return "Name is required";
                }
                return null;
              },
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
                  timeStart.substring(0, 10) + " " + timeStart.substring(11, 16)),
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
                  Text(timeEnd.substring(0, 10) + " " + timeEnd.substring(11, 16)),
              trailing: Icon(
                Icons.calendar_today,
                color: Color(0xFF00C853),
              ),
              onTap: () {
                _pickDateTime(timeEnd).then((value) {
                  var endFormat =
                      value.substring(0, 10) + " " + value.substring(11, 16);
                  var startFormat = timeStart.substring(0, 10) +
                      " " +
                      timeStart.substring(11, 16);

                  DateTime start =
                      DateFormat("yyyy-MM-dd hh:mm").parse(startFormat);
                  DateTime end =
                      DateFormat("yyyy-MM-dd hh:mm").parse(endFormat);

                  if (end.isBefore(start)) {
                    MySnackbar.showSnackbar(
                        context, "Time End is before Time Start!");
                  } else {
                    this.setState(() {
                      timeEnd = value;
                    });
                  }
                });
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
                    fileChanged = true;
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
                          "Download",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        canLaunch(script.url).then((value) {
                          if (value) {
                            launch(script.url);
                          } else {
                            MySnackbar.showSnackbar(
                                context, "Cannot open the file.");
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("Status:"),
            ),
            _buildStatus(),
            (() {
              if (scenarioData.createdTime != null &&
                  scenarioData.createdBy != null) {
                return Column(
                  children: [
                    ListTile(
                      title: Text("Created Time"),
                      subtitle: Text(scenarioData.createdTime.substring(0, 10) +
                          " " +
                          scenarioData.createdTime.substring(11, 19)),
                    ),
                    ListTile(
                      title: Text("Created By"),
                      subtitle: Text(scenarioData.createdBy.fullname +
                          " - @" +
                          scenarioData.createdBy.username),
                    ),
                  ],
                );
              } else {
                return Container(
                  height: 0,
                  width: 0,
                );
              }
            }()),
            (() {
              if (scenarioData.lastModified != null &&
                  scenarioData.lastModifiedBy != null) {
                return Column(
                  children: [
                    ListTile(
                      title: Text("Last Modified"),
                      subtitle: Text(
                          scenarioData.lastModified.substring(0, 10) +
                              " " +
                              scenarioData.lastModified.substring(11, 19)),
                    ),
                    ListTile(
                      title: Text("Last Modified By"),
                      subtitle: Text(scenarioData.lastModifiedBy.fullname +
                          " - @" +
                          scenarioData.lastModifiedBy.username),
                    ),
                  ],
                );
              } else {
                return Container(
                  height: 0,
                  width: 0,
                );
              }
            }()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus() {
    return Container(
      child: Column(
        children: [
          RadioListTile(
            value: -1,
            activeColor: Color(0xFF00C853),
            title: Text("Hủy"),
            groupValue: status,
            onChanged: (value) {
              this.setState(() {
                status = value;
              });
              print(status.toString());
            },
          ),
          RadioListTile(
            value: 0,
            activeColor: Color(0xFF00C853),
            title: Text("Đang chờ"),
            groupValue: status,
            onChanged: (value) {
              this.setState(() {
                status = value;
              });
              print(status.toString());
            },
          ),
          RadioListTile(
            value: 1,
            activeColor: Color(0xFF00C853),
            title: Text("Đang quay"),
            groupValue: status,
            onChanged: (value) {
              this.setState(() {
                status = value;
              });
              print(status.toString());
            },
          ),
          RadioListTile(
            value: 2,
            activeColor: Color(0xFF00C853),
            title: Text("Hoàn thành"),
            groupValue: status,
            onChanged: (value) {
              this.setState(() {
                status = value;
              });
              print(status.toString());
            },
          ),
        ],
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

  void loadData() async {
    _detailBloc = ScenarioDetailBloc(context);

    setState(() {
      isLoading = true;
    });

    var scenario = await _detailBloc.getScenarioById(scenarioId);

    setState(() {
      isLoading = false;
      scenarioData = scenario;

      status = scenarioData.status;
      timeStart = scenarioData.timeStart;
      timeEnd = scenarioData.timeEnd;

      if (scenarioData.script != null && scenarioData.script.isNotEmpty) {
        script.filename = MyFile.getFilename(scenarioData.script);
        script.url = scenarioData.script;
      }

      _nameController.text = scenarioData.name;
      _descriptionController.text = scenarioData.description;
      _locationController.text = scenarioData.location;
      _recordQuantityController.text =
          scenarioData.recordQuantity.toString() != "null"
              ? scenarioData.recordQuantity.toString()
              : "0";
    });
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

  void _showDialogConfirmDelete() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm Delete"),
          content:
              new Text("Do you want to delete scence " + scenarioData.name),
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
                _detailBloc.deleteScence(scenarioId).then((value) {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
