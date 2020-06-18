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
  MyOrdersClickEvent
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
    }
  }
}
