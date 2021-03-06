import 'package:file_picker/file_picker.dart';
import 'package:film_management/src/blocs/director/manage_equipment/equipment_detail_bloc.dart';
import 'package:film_management/src/blocs/director/manage_scenario/scenario_detail_bloc.dart';
import 'package:film_management/src/constants/env_variable.dart';
import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/equipment.dart';
import 'package:film_management/src/models/equipment_image.dart';
import 'package:film_management/src/models/my_file.dart';
import 'package:film_management/src/models/my_img.dart';
import 'package:film_management/src/models/scenario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class DirectorEquipmentDetailScr extends StatefulWidget {
  final equipmentId;

  const DirectorEquipmentDetailScr({Key key, this.equipmentId})
      : super(key: key);

  @override
  _DirectorEquipmentDetailScrState createState() =>
      _DirectorEquipmentDetailScrState(equipmentId);
}

class _DirectorEquipmentDetailScrState
    extends State<DirectorEquipmentDetailScr> {
  EquipmentDetailBloc _detailBloc;
  final equipmentId;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();

  bool isLoading = true;
  Equipment equipmentData;
  List<MyImage> listImg;

  _DirectorEquipmentDetailScrState(this.equipmentId);

  @override
  void initState() {
    super.initState();
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
          "Equipment Detail",
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: Text(
                "Images",
                style: TextStyle(fontSize: 15),
              ),
            ),
            _buildListImg(),
            (() {
              if (equipmentData.createTime != null &&
                  equipmentData.createBy != null) {
                return Column(
                  children: [
                    ListTile(
                      title: Text("Created Time"),
                      subtitle: Text(equipmentData.createTime.substring(0, 10) +
                          " " +
                          equipmentData.createTime.substring(11, 19)),
                    ),
                    ListTile(
                      title: Text("Created By"),
                      subtitle: Text(equipmentData.createBy.fullname +
                          " - @" +
                          equipmentData.createBy.username),
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
              if (equipmentData.lastModified != null &&
                  equipmentData.lastModifiedBy != null) {
                return Column(
                  children: [
                    ListTile(
                      title: Text("Last Modified"),
                      subtitle: Text(
                          equipmentData.lastModified.substring(0, 10) +
                              " " +
                              equipmentData.lastModified.substring(11, 19)),
                    ),
                    ListTile(
                      title: Text("Last Modified By"),
                      subtitle: Text(equipmentData.lastModifiedBy.fullname +
                          " - @" +
                          equipmentData.lastModifiedBy.username),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ButtonTheme(
                    buttonColor: Color(0xFF00C853),
                    child: RaisedButton(
                      child: Text(
                        "UPDATE",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          equipmentData.name = _nameController.text;
                          equipmentData.description =
                              _descriptionController.text;

                          var quantity = _quantityController.text != null &&
                                  _quantityController.text.trim().isNotEmpty
                              ? _quantityController.text.trim()
                              : "0";

                          equipmentData.quantity = int.parse(quantity);

                          _showProcessingDialog();
                          _detailBloc.update(equipmentData, listImg).then((value) {
                            Navigator.of(context).pop();
                          });
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: ButtonTheme(
                    buttonColor: Color(0xFFF44336),
                    child: RaisedButton(
                      child: Text(
                        "DELETE",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _showDialogConfirmDelete();
                      },
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

  _buildListImg() {
    if (listImg == null)
      return Container(
        height: 0,
        width: 0,
      );

    return Container(
      child: Column(
        children: [
          (() {
            var listWidget = <Widget>[];
            for (var img in listImg) {
              print(img.url);
              listWidget.add(_buildEachImg(img));
            }
            return Column(
              children: listWidget,
            );
          }()),
          Container(
            child: Center(
              child: ButtonTheme(
                buttonColor: Color(0xFF00C853),
                child: RaisedButton(
                  child: Text(
                    "Add image",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    ImagePicker.pickImage(source: ImageSource.gallery).then((img) {
                      MyImage fileImg = MyImage();

                      fileImg.imgFile = img;
                      fileImg.url = img.path;
                      fileImg.isDelete = false;
                      fileImg.isNew = true;
                      
                      this.setState(() {
                        listImg.add(fileImg);
                      });
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildEachImg(MyImage img) {
    if (img.isDelete) return Container(width: 0, height: 0,);
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Container(
              width: 230,
              height: 230,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(width: 1, color: Color(0xFF00C853)),
                image: new DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: img.imgFile == null ? new NetworkImage(img.url) : FileImage(img.imgFile),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              print('tap ' + listImg.indexOf(img).toString());
              this.setState(() {
                if (img.isNew) {
                  listImg.removeAt(listImg.indexOf(img));
                } else {
                  img.isDelete = true;
                }
              });
            },
            child: Icon(Icons.close, color: Color(0xFFF44336),),
          ),
        ),
      ],
    );
  }

  void loadData() async {
    _detailBloc = EquipmentDetailBloc(context);

    setState(() {
      isLoading = true;
    });

    var equipment = await _detailBloc.getById(equipmentId);

    setState(() {
      isLoading = false;
      equipmentData = equipment;

      if (equipment.listImages == null)
        equipment.listImages = List<EquipmentImage>();

      listImg = equipment.listImages
          .map<MyImage>((img) => MyImage.fromURL(img.url, img.id))
          .toList();

      _nameController.text = equipmentData.name;
      _descriptionController.text = equipmentData.description;
      _quantityController.text = equipmentData.quantity.toString() != "null"
          ? equipmentData.quantity.toString()
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
          title: new Text("Confirm Active"),
          content:
              new Text("Do you want to delete equipment " + equipmentData.name),
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
                _detailBloc.delete(equipmentId).then((value) {
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
