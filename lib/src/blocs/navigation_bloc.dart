import 'package:bloc/bloc.dart';
import 'package:film_management/src/blocs/authentication_bloc.dart';
import 'package:film_management/src/blocs/logout_bloc.dart';
import 'package:film_management/src/constants/screen_routes.dart';
import 'package:film_management/src/screens/widgets/pages/homepage.dart';
import 'package:film_management/src/screens/widgets/pages/myaccount_page.dart';
import 'package:film_management/src/screens/widgets/pages/myorders_page.dart';
import 'package:flutter/material.dart';

enum NavigationEvents {
  HomePageClickEvent,
  MyAccountClickedEvent,
  MyOrdersClickEvent,
  LogoutClickEvent
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  final LogoutBloc _logoutBloc = LogoutBloc();
  final AuthenticationBloc _authBloc = AuthenticationBloc();
  final BuildContext _context;

  NavigationBloc(this._context);

  @override
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickEvent:
        yield HomePage();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield MyAccountsPage();
        break;
      case NavigationEvents.MyOrdersClickEvent:
        yield MyOrdersPage();
        break;
      case NavigationEvents.LogoutClickEvent:
        _logoutBloc.processLogout();
        
        break;
    }
  }

  void processLogout() {
    _logoutBloc.processLogout();
    _logoutBloc.processResult.listen((result) { 
      if (!result) {
        _logoutBloc.processMessage.listen((message) {
          _snowSnackbar(message);
        });
        // Navigator.popUntil(_context, ModalRoute.withName(Navigator.defaultRouteName));
        // Navigator.push(_context, MaterialPageRoute(builder: (context) => ScreenRoute.LOGIN_SRC));
        Navigator.of(_context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ScreenRoute.LOGIN_SRC), (route) => false);
      } else {
        _authBloc.closeSession();
      }
    });
  }

  void _snowSnackbar(String message) {
    Scaffold.of(_context).hideCurrentSnackBar();

    if (message != null && message.trim().length > 0) {
      Scaffold.of(_context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }
}
