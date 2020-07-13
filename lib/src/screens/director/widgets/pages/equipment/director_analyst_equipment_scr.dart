import 'package:film_management/src/blocs/director/manage_equipment/analyst_equipment_bloc.dart';
import 'package:film_management/src/constants/env_variable.dart';
import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/equipment.dart';
import 'package:film_management/src/screens/director/widgets/pages/equipment/director_add_equipment_scr.dart';
import 'package:film_management/src/screens/director/widgets/pages/equipment/director_equipment_detail_scr.dart';
import 'package:film_management/src/screens/director/widgets/sidebar/director_sidebar_layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DirectorAnalystEquipmentScr extends StatefulWidget {
  @override
  _DirectorAnalystEquipmentScrState createState() =>
      _DirectorAnalystEquipmentScrState();
}

class _DirectorAnalystEquipmentScrState
    extends State<DirectorAnalystEquipmentScr> {
  AnalystEquipmentBloc _listBloc;
  String timeStart;
  String timeEnd;

  @override
  void initState() {
    super.initState();
    timeStart = DateTime.now().toString().substring(0, 16);
    timeEnd = timeStart;
  }

  @override
  Widget build(BuildContext context) {
    _listBloc = AnalystEquipmentBloc(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Analyst Equipment",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 28),
                      ),
                      _buildSearch(),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonTheme(
                              minWidth: 10,
                              buttonColor: Color(0xFF00C853),
                              child: RaisedButton(
                                child: Container(
                                  child: Text(
                                    "Start",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  print('start ' + timeStart);
                                  print('end ' + timeEnd);
                                  _listBloc.getList(timeStart, timeEnd);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: _listBloc.listEquipment,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var listWidget = <Widget>[];

                            if (snapshot.data.isEmpty) {
                              return Text("Enter time to search");
                            }
                            snapshot.data.forEach((equip) {
                              listWidget.add(
                                  this._buildEquipmentRecord(equip, context));
                            });

                            return Column(
                              children: listWidget,
                            );
                          }
                          return Text("Enter time to start");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      child: Column(
        children: [
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
            subtitle: Text(
                timeEnd.substring(0, 10) + " " + timeEnd.substring(11, 16)),
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
                DateTime end = DateFormat("yyyy-MM-dd hh:mm").parse(endFormat);

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
        ],
      ),
    );
  }

  Widget _buildEquipmentRecord(Equipment equipment, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: equipment.quantity > 0 ? Color(0xFFE6EE9C) : Color(0xFFFFCCBC),
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
          print("tap to see detail of " + equipment.id.toString());
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DirectorSideBarLayout(
                      screen: DirectorEquipmentDetailScr(
                        equipmentId: equipment.id,
                      ),
                    )),
          ).then((value) => _listBloc.getList(timeStart, timeEnd));
        },
        child: Row(
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
                                equipment.listImages != null &&
                                        equipment.listImages.isNotEmpty
                                    ? equipment.listImages[0].url
                                    : DEFAULT_AVATAR),
                          ),
                        ),
                      ),
                      equipment.status
                          ? Container(
                              width: 0,
                              height: 0,
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.grey.withOpacity(0.8),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                              ),
                            )
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
                    equipment.name,
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
                    'Quantity: ' + equipment.quantity.toString(),
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
                    equipment.lastModified != null
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
                    equipment.lastModified != null
                        ? (equipment.lastModified.substring(0, 10) +
                            " " +
                            equipment.lastModified.substring(11, 19))
                        : (equipment.createTime.substring(0, 10) +
                            " " +
                            equipment.createTime.substring(11, 19)),
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
