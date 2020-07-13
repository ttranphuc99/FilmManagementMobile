import 'package:film_management/src/blocs/director/manage_equipment/list_equipment_bloc.dart';
import 'package:film_management/src/constants/env_variable.dart';
import 'package:film_management/src/models/equipment.dart';
import 'package:film_management/src/screens/director/widgets/pages/actor/director_add_actor_scr.dart';
import 'package:film_management/src/screens/director/widgets/pages/equipment/director_add_equipment_scr.dart';
import 'package:film_management/src/screens/director/widgets/pages/equipment/director_equipment_detail_scr.dart';
import 'package:film_management/src/screens/director/widgets/sidebar/director_sidebar_layout.dart';
import 'package:flutter/material.dart';

class DirectorManageEquipmentScr extends StatefulWidget {
  @override
  _DirectorManageEquipmentScrState createState() =>
      _DirectorManageEquipmentScrState();
}

class _DirectorManageEquipmentScrState
    extends State<DirectorManageEquipmentScr> {
  ListEquipmentBloc _listBloc;

  @override
  Widget build(BuildContext context) {
    _listBloc = ListEquipmentBloc(context);
    _listBloc.getList();

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
                        "Manage Equipment",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 28),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                TextField(
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    _listBloc.search(value);
                                  },
                                  style: TextStyle(
                                    color: Color(0xFF212121),
                                    fontFamily: 'OpenSans',
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFE6EE9C), width: 7.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFFFCCBC), width: 3.0),
                                    ),
                                    contentPadding: EdgeInsets.only(top: 14.0),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Color(0xFF212121),
                                    ),
                                    hintText: 'Search by name...',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF212121),
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: _listBloc.listEquipment,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var listWidget = <Widget>[];

                            if (snapshot.data.isEmpty) {
                              return Text("Not found any equipments!");
                            }
                            snapshot.data.forEach((equip) {
                              listWidget.add(
                                  this._buildEquipmentRecord(equip, context));
                            });

                            return Column(
                              children: listWidget,
                            );
                          }
                          return Text("Loading...");
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
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => DirectorSideBarLayout(
                              screen: DirectorAddEquipmentScr()),
                        ),
                      )
                      .then((value) => _listBloc.getList());
                },
              ),
            ),
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
        color: equipment.status ? Color(0xFFE6EE9C) : Color(0xFFFFCCBC),
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
          ).then((value) => _listBloc.getList());
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
                            fit: BoxFit.fitWidth,
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
                    equipment.lastModified != null ? 'Last Modified: ' : 'Created Time',
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
}
