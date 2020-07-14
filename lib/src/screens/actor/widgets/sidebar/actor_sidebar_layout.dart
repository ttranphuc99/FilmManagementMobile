import 'package:film_management/src/models/notification.dart';
import 'package:film_management/src/screens/actor/widgets/pages/actor_dashboard_scr.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:film_management/src/blocs/noti_bloc.dart';
import 'actor_sidebar.dart';

class ActorSideBarLayout extends StatefulWidget {
  final Widget screen;

  const ActorSideBarLayout({Key key, this.screen}) : super(key: key);

  @override
  _ActorSideBarLayoutState createState() => _ActorSideBarLayoutState(screen);
}

class _ActorSideBarLayoutState extends State<ActorSideBarLayout> {
  final Widget screen;
  final FirebaseMessaging _firebaseMess = FirebaseMessaging();
  NotiBloc _bloc;

  _ActorSideBarLayoutState(this.screen);

  @override
  void initState() {
    super.initState();
    _bloc = NotiBloc(context);

    _firebaseMess.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
        _bloc.addNoti(message);
        print('after');
      },
      onLaunch: (message) async {},
      onResume: (message) async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        screen ?? ActorDashboardScr(),
        ActorSideBar(),
        Align(
          alignment: Alignment.topCenter,
          child: StreamBuilder(
            stream: _bloc.stream,
            builder: (context, snapshot) {
              print('in build noti');
              if (snapshot.hasData) {
                var noti = snapshot.data as MyNotification;

                if (noti.isShow ?? false) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 150,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              noti.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              noti.content,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
              return Container(
                width: 0,
                height: 0,
              );
            },
          ),
        ),
      ],
    ));
  }
}
