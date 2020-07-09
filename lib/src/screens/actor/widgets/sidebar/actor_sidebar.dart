import 'dart:async';

import 'package:film_management/src/blocs/authentication_bloc.dart';
import 'package:film_management/src/blocs/logout_bloc.dart';
import 'package:film_management/src/constants/env_variable.dart';
import 'package:film_management/src/models/account.dart';
import 'package:film_management/src/screens/guest/change_pass_scr.dart';
import 'package:film_management/src/screens/actor/widgets/pages/actor_dashboard_scr.dart';
import 'package:film_management/src/screens/guest/profile_scr.dart';
import 'package:film_management/src/screens/actor/widgets/sidebar/actor_menu_item.dart';
import 'package:film_management/src/screens/actor/widgets/sidebar/actor_sidebar_layout.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ActorSideBar extends StatefulWidget {
  @override
  _ActorSideBarState createState() => _ActorSideBarState();
}

class _ActorSideBarState extends State<ActorSideBar>
    with SingleTickerProviderStateMixin<ActorSideBar> {
  AnimationController _controller;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 250);
  final _authBloc = AuthenticationBloc();
  final _logoutBloc = LogoutBloc();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
  }

  void onIconPress() {
    final animationStatus = _controller.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _controller.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _controller.forward();
    }
  }

  Widget buildProfile() {
    return StreamBuilder(
      stream: _authBloc.accountProfile,
      builder: (context, accountData) {
        if (accountData.hasData) {
          var account = accountData.data as Account;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActorSideBarLayout(
                      screen: ProfileScr(
                    isAdmin: false,
                  )),
                ),
              );
            },
            child: ListTile(
              title: Text(
                account.fullname ?? "",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              subtitle: Text(
                account.username ?? "",
                style: TextStyle(
                  color: Color(0xFFB9F6CA),
                  fontSize: 15,
                ),
              ),
              leading: Container(
                width: 60,
                height: 60,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: new NetworkImage(account.image ?? DEFAULT_AVATAR),
                  ),
                ),
              ),
            ),
          );
        }
        return Text("");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _authBloc.getProfile();
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSidebarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSidebarOpenedAsync.data ? 0 : -screenWidth,
          right: isSidebarOpenedAsync.data ? 0 : screenWidth - 45,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).copyWith().size.height,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      color: Color(0xFF00C853),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          buildProfile(),
                          Divider(
                            height: 32,
                            thickness: 0.5,
                            color: Colors.white.withOpacity(0.3),
                            indent: 32,
                            endIndent: 32,
                          ),
                          ActorMenuItem(
                            icon: Icons.home,
                            title: "Home",
                            onTap: () {
                              onIconPress();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActorSideBarLayout(
                                        screen: ActorDashboardScr()),
                                  ),
                                  (route) => false);
                            },
                          ),
                          Divider(
                            height: 64,
                            thickness: 0.5,
                            color: Colors.white.withOpacity(0.3),
                            indent: 32,
                            endIndent: 32,
                          ),
                          ActorMenuItem(
                            icon: Icons.lock_open,
                            title: "Change password",
                            onTap: () {
                              onIconPress();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActorSideBarLayout(
                                      screen: ChangePassScr(
                                    isAdmin: false,
                                  )),
                                ),
                              );
                            },
                          ),
                          ActorMenuItem(
                            icon: Icons.exit_to_app,
                            title: "Logout",
                            onTap: () {
                              print('btnLogout clicked');
                              _logoutBloc.processLogout(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.9),
                    child: GestureDetector(
                      onTap: () {
                        onIconPress();
                      },
                      child: ClipPath(
                        clipper: CustomMenuClipper(),
                        child: Container(
                          width: 35,
                          height: 110,
                          color: Color(0xFF00C853),
                          alignment: Alignment.centerLeft,
                          child: AnimatedIcon(
                            progress: _controller.view,
                            icon: AnimatedIcons.menu_close,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    Path path = Path();

    final width = size.width;
    final height = size.height;

    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
