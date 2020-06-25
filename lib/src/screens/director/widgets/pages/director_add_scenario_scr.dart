import 'package:file_picker/file_picker.dart';
import 'package:film_management/src/constants/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DirectorAddScenarioScr extends StatefulWidget {
  @override
  _DirectorAddScenarioScrState createState() => _DirectorAddScenarioScrState();
}

class _DirectorAddScenarioScrState extends State<DirectorAddScenarioScr> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _recordQuantityController = TextEditingController();

  String timeStart;
  String timeEnd;
  String scriptFilename;
  int status;

  @override
  void initState() {
    super.initState();
    timeStart = DateTime.now().toString().substring(0, 16);
    timeEnd = timeStart;
    status = 0;
    scriptFilename = "";
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name",
            ),
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: "Description",
            ),
          ),
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: "Location",
            ),
          ),
          ListTile(
            title: Text("Time start:"),
            subtitle: Text(timeStart),
            trailing: Icon(Icons.calendar_today),
            onTap: () {
              _pickDateTime(timeStart).then((value) => this.setState(() {
                    timeStart = value;
                  }));
            },
          ),
          ListTile(
            title: Text("Time end:"),
            subtitle: Text(timeEnd),
            trailing: Icon(Icons.calendar_today),
            onTap: () {
              _pickDateTime(timeEnd).then((value) => this.setState(() {
                    timeEnd = value;
                  }));
            },
          ),
          TextFormField(
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
            title: Text("Script:"),
            subtitle: Text(scriptFilename ?? ""),
            trailing: Icon(Icons.file_upload),
            onTap: () {
              FilePicker.getFile()
              .then((file) {
                var filename = file.path.substring(file.path.lastIndexOf('/') + 1);
                var extendsion = filename.substring(filename.lastIndexOf('.') + 1);
                
                if (extendsion != 'pdf' && extendsion != 'doc') {
                  MySnackbar.showSnackbar(context, "File extension is not allow");
                  return;
                }

                setState(() {
                  scriptFilename = filename;
                });
              });
            },
          ),
          _buildStatus(),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    return Container(
      child: Column(
        children: [
          RadioListTile(
            value: -1,
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
}
