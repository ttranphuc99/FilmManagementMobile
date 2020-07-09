import 'package:film_management/src/screens/actor/widgets/pages/actor_dashboard_scr.dart';
import 'package:film_management/src/screens/actor/widgets/sidebar/actor_sidebar_layout.dart';
import 'package:film_management/src/screens/director/widgets/pages/director_dashboard_scr.dart';
import 'package:film_management/src/screens/director/widgets/sidebar/director_sidebar_layout.dart';
import 'package:flutter/material.dart';
import 'package:film_management/src/blocs/change_pass_bloc.dart';

class ChangePassScr extends StatefulWidget {
  final bool isAdmin;

  const ChangePassScr({Key key, this.isAdmin}) : super(key: key);

  @override
  _ChangePassScrState createState() => _ChangePassScrState(isAdmin);
}

class _ChangePassScrState extends State<ChangePassScr> {
  final bool isAdmin;
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  ChangePassBloc _bloc;

  _ChangePassScrState(this.isAdmin);

  @override
  Widget build(BuildContext context) {
    _bloc = ChangePassBloc(context);

    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              _buildTitle(),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Container(
        child: Text(
          "Change password",
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
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New password",
              ),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return "New password is required";
                } else if (value.length < 6) {
                  return "Password is minimum 6 characters";
                }
                return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              cursorColor: Color(0xFF00C853),
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm password",
              ),
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return "Confirm password is not match";
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
                  "CHANGE",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _showProcessingDialog();
                    _bloc.changePass(_newPasswordController.text).then((value) {
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
