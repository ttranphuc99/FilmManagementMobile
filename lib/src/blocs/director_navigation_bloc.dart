import 'package:bloc/bloc.dart';
import 'package:film_management/src/screens/director/widgets/pages/director_dashboard_scr.dart';
import 'package:film_management/src/screens/director/widgets/pages/director_manage_actor_scr.dart';

enum DirectorNavigationEvents {
  DashBoardEvent,
  ManageActorEvent
}

abstract class DirectorNavigationStates {}

class DirectorNavigationBloc extends Bloc<DirectorNavigationEvents, DirectorNavigationStates> {
  @override
  DirectorNavigationStates get initialState => DirectorDashboardScr();

  @override
  Stream<DirectorNavigationStates> mapEventToState(DirectorNavigationEvents event) async* {
    switch (event) {
      case DirectorNavigationEvents.DashBoardEvent:
        yield DirectorDashboardScr();
        break;
      case DirectorNavigationEvents.ManageActorEvent:
        yield DirectorManageActorScr();
        break;
    }
  }
}
