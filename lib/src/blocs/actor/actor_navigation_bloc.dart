import 'package:bloc/bloc.dart';
import 'package:film_management/src/screens/actor/widgets/pages/actor_dashboard_scr.dart';
import 'package:film_management/src/screens/actor/widgets/pages/actor_scr.dart';

enum ActorNavigationEvents {
  DashBoardEvent,
  ScrEvent
}

abstract class ActorNavigationStates {}

class ActorNavigationBloc extends Bloc<ActorNavigationEvents, ActorNavigationStates> {
  @override
  ActorNavigationStates get initialState => ActorDashboardScr();

  @override
  Stream<ActorNavigationStates> mapEventToState(ActorNavigationEvents event) async* {
    switch (event) {
      case ActorNavigationEvents.DashBoardEvent:
        yield ActorDashboardScr();
        break;
      case ActorNavigationEvents.ScrEvent:
        yield ActorScr();
        break;
    }
  }
}
