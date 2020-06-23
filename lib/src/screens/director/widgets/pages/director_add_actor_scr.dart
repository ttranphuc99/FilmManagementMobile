import 'package:film_management/src/blocs/director/manage_actor/add_actor_bloc.dart';
import 'package:film_management/src/constants/snackbar.dart';
import 'package:film_management/src/models/account.dart';
import 'package:flutter/material.dart';

class DirectorAddActorScr extends StatefulWidget {
  @override
  _DirectorAddActorScrState createState() => _DirectorAddActorScrState();
}

class _DirectorAddActorScrState extends State<DirectorAddActorScr> {
  final _formKey = GlobalKey<FormState>();
  AddActorBloc _accBloc;
  final _usernameController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _accBloc = AddActorBloc(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 30, bottom: 30, left: 40, right: 60),
        child: Container(
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
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Container(
        child: Text(
          "Add new actor",
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
          ListTile(
            leading: Icon(Icons.perm_identity),
            title: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Username",
              ),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Username cannot empty';
                }
                return null;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: TextFormField(
              controller: _fullnameController,
              decoration: InputDecoration(
                hintText: "Fullname",
              ),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Fullname cannot empty';
                }
                return null;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Phone",
              ),
              validator: (value) {
                if (value.length > 15) {
                  return 'Phone cannot longer than 10 character';
                }
                return null;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email",
              ),
              validator: (value) {
                if (value.isNotEmpty && !value.contains('@')) {
                  return 'Email is invalid';
                }
                return null;
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: RaisedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState.validate()) {
                    Account account = Account.emptyAccount();

                    account.username = _usernameController.text;
                    account.fullname = _fullnameController.text;
                    account.phone = _phoneController.text;
                    account.email = _emailController.text;

                    _showDialogConfirmActive();
                    _accBloc.addAccount(account).then((value) {
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Text(
                  "ADD",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                color: Color(0xFF00C853),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDialogConfirmActive() {
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
