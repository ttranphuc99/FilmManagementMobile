import 'package:film_management/src/blocs/profile_bloc.dart';
import 'package:film_management/src/constants/env_variable.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/models/my_img.dart';
import 'package:film_management/src/screens/actor/widgets/pages/actor_dashboard_scr.dart';
import 'package:film_management/src/screens/actor/widgets/sidebar/actor_sidebar_layout.dart';
import 'package:film_management/src/screens/director/widgets/pages/director_dashboard_scr.dart';
import 'package:film_management/src/screens/director/widgets/sidebar/director_sidebar_layout.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScr extends StatefulWidget {
  final bool isAdmin;

  const ProfileScr({Key key, this.isAdmin}) : super(key: key);

  @override
  _ProfileScrState createState() => _ProfileScrState(isAdmin);
}

class _ProfileScrState extends State<ProfileScr> {
  final isAdmin;

  final _formKey = GlobalKey<FormState>();
  final _fullnameTxt = TextEditingController();
  final _descriptionTxt = TextEditingController();
  final _phoneTxt = TextEditingController();
  final _emailTxt = TextEditingController();
  MyImage avatar;
  ProfileBloc _bloc;
  Account profile = Account.emptyAccount();

  _ProfileScrState(this.isAdmin);

  @override
  void initState() {
    super.initState();
    _bloc = ProfileBloc(context);
    avatar = MyImage();
    _bloc.loadData().then((profile) {
      if (profile != null) {
        _fullnameTxt.text = profile.fullname;
        _phoneTxt.text = profile.phone;
        _emailTxt.text = profile.email;
        _descriptionTxt.text = profile.description;
      }
    });
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
        padding: EdgeInsets.symmetric(horizontal: 48, vertical: 32),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: StreamBuilder(
              stream: _bloc.profile,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  profile = snapshot.data as Account;
                  if (profile.image == null) {
                    avatar.url = DEFAULT_AVATAR;
                  } else {
                    avatar.url = profile.image;
                  }

                  return Column(
                    children: [
                      _buildTitle(),
                      SizedBox(height: 15),
                      _buildImageLayout(avatar),
                      SizedBox(
                        height: 15,
                      ),
                      _buildForm(),
                    ],
                  );
                }
                return Text("Loading...");
              },
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
          "Profile @" + profile.username,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
        ),
      ),
    );
  }

  Widget _buildImageLayout(MyImage img) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: img.imgFile == null
                        ? new NetworkImage(img.url)
                        : FileImage(img.imgFile),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonTheme(
                    minWidth: 10,
                    buttonColor: Color(0xFF00C853),
                    child: RaisedButton(
                      child: Container(
                        child: Text(
                          "Remove Avatar",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (avatar.url != DEFAULT_AVATAR) {
                          setState(() {
                            avatar.imgFile = null;
                            avatar.url = DEFAULT_AVATAR;
                            avatar.isNew = true;
                            avatar.isDelete = true;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  ButtonTheme(
                    minWidth: 10,
                    buttonColor: Color(0xFF00C853),
                    child: RaisedButton(
                      child: Container(
                        child: Text(
                          "Change avatar",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        ImagePicker.pickImage(source: ImageSource.gallery)
                            .then((img) {
                          setState(() {
                            avatar.isNew = true;
                            avatar.isDelete = false;
                            avatar.imgFile = img;
                            avatar.url = null;
                          });
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
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
              controller: _fullnameTxt,
              decoration: InputDecoration(
                labelText: "Fullname",
              ),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return "Fullname is required";
                } else if (value.length > 20) {
                  return "Password is maximum 20 characters";
                }
                return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              cursorColor: Color(0xFF00C853),
              controller: _phoneTxt,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Phone",
              ),
              validator: (value) {
                if (value.trim().isNotEmpty && value.length > 15) {
                  return "Phone is maximum 15 characters";
                }
                return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              cursorColor: Color(0xFF00C853),
              controller: _emailTxt,
              decoration: InputDecoration(
                labelText: "Email",
              ),
              validator: (value) {
                if (value.isNotEmpty && !value.contains('@')) {
                  return 'Email is invalid';
                }
                return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              cursorColor: Color(0xFF00C853),
              controller: _descriptionTxt,
              decoration: InputDecoration(
                labelText: "Description",
              ),
              validator: (value) {
                if (value.isNotEmpty && value.length > 100) {
                  return 'Description is maximum 100 characters';
                }
                return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            ButtonTheme(
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
                    profile.fullname = _fullnameTxt.text;
                    profile.phone = _phoneTxt.text;
                    profile.description = _descriptionTxt.text;
                    profile.email = _emailTxt.text;

                    this._showProcessingDialog();

                    this._bloc.update(profile, avatar).then((value) {
                      Navigator.of(context).pop();

                      if (value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => isAdmin
                                  ? DirectorSideBarLayout(
                                      screen: DirectorDashboardScr(),
                                    )
                                  : ActorSideBarLayout(
                                      screen: ActorDashboardScr(),
                                    ),
                            ),
                            (route) => false);
                      }
                    });
                  }
                },
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
