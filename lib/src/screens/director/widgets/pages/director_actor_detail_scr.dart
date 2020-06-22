import 'package:film_management/assets/styles/constants.dart';
import 'package:film_management/src/blocs/director/manage_actor/actor_detail_bloc.dart';
import 'package:film_management/src/blocs/director/manage_actor/block_actor_bloc.dart';
import 'package:film_management/src/constants/env_variable.dart';
import 'package:film_management/src/models/account.dart';
import 'package:flutter/material.dart';

class DirectorActorDetailScr extends StatefulWidget {
  final int actorId;

  const DirectorActorDetailScr({Key key, this.actorId}) : super(key: key);

  @override
  _DirectorActorDetailScrState createState() =>
      _DirectorActorDetailScrState(actorId);
}

class _DirectorActorDetailScrState extends State<DirectorActorDetailScr> {
  final int actorId;
  ActorDetailBloc _actorDetailBloc;

  _DirectorActorDetailScrState(this.actorId);

  @override
  Widget build(BuildContext context) {
    _actorDetailBloc = ActorDetailBloc(context);
    _actorDetailBloc.fetchData(actorId);

    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: StreamBuilder(
            stream: _actorDetailBloc.accountInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    children: [
                      _buildImageLayout(snapshot.data),
                      _buildFullnameLayout(snapshot.data),
                      _buildUsernameLayout(snapshot.data),
                      Divider(
                        height: 32,
                        thickness: 0.5,
                        color: Colors.black,
                        indent: 0,
                        endIndent: 0,
                      ),
                      _buildPhoneLayout(snapshot.data),
                      _buildEmailLayout(snapshot.data),
                      Divider(
                        height: 32,
                        thickness: 0.5,
                        color: Colors.black,
                        indent: 0,
                        endIndent: 0,
                      ),
                      _buildDescriptionLayout(snapshot.data),
                      Divider(
                        height: 32,
                        thickness: 0.5,
                        color: Colors.black.withOpacity(0.3),
                        indent: 0,
                        endIndent: 0,
                      ),
                      (snapshot.data.status)
                          ? _buildBlockBtn(snapshot.data)
                          : _buildActiveBtn(snapshot.data),
                    ],
                  ),
                );
              }

              return StreamBuilder(
                stream: _actorDetailBloc.isLoading,
                builder: (context, snapshot) {
                  return Container(
                    child: (snapshot.hasData && snapshot.data)
                        ? CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.green),
                          )
                        : null,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageLayout(Account account) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(
                      account.image != null && account.image.isNotEmpty
                          ? account.image
                          : DEFAULT_AVATAR),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameLayout(Account account) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text(
              "@" + account.username,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullnameLayout(Account account) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Column(
          children: [
            Text(
              account.fullname,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneLayout(Account account) {
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Icon(
            Icons.phone,
            color: Colors.black,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            account.phone ?? "",
            style: TextStyle(color: Colors.black, fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _buildEmailLayout(Account account) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Icon(
            Icons.email,
            color: Colors.black,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            account.email ?? "",
            style: TextStyle(color: Colors.black, fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _buildDescriptionLayout(Account account) {
    if (account.description != null && account.description.length > 0) {
      return Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        child: Center(
          child: Column(
            children: [
              Text(
                '"' + (account.description ?? "") + '"',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: 0,
      height: 20,
    );
  }

  Widget _buildActiveBtn(Account account) {
    return Container(
      alignment: AlignmentDirectional.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 40,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () {
                print('btnActive pressed');
                _showDialogConfirmActive(account);
              },
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Color(0xFFAED581),
              child: Text(
                'ACTIVE',
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockBtn(Account account) {
    return Container(
      alignment: AlignmentDirectional.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 40,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () {
                print('btnBlock pressed');
                _showDialogConfirmBlock(account.id);
              },
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Color(0xFFF44336),
              child: Text(
                'BLOCK',
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialogConfirmBlock(int id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm Block"),
          content: new Text("Do you want to block ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Accept"),
              onPressed: () async {
                final _blockAccBloc = BlockActorBloc(this.context);
                var result = await _blockAccBloc.blockAccount(id);

                if (result) {
                  _actorDetailBloc.fetchData(id);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogConfirmActive(Account account) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm Active"),
          content: new Text("Do you want to active " + account.fullname),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Accept"),
              onPressed: () async {
                account.status = true;
                final _blockAccBloc = BlockActorBloc(this.context);
                var result = await _blockAccBloc.activeAccount(account);

                if (result) {
                  _actorDetailBloc.fetchData(account.id);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
