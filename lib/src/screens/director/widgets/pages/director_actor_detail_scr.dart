import 'package:film_management/src/blocs/director/manage_actor/actor_detail_bloc.dart';
import 'package:flutter/material.dart';

class DirectorActorDetailScr extends StatefulWidget {
  final int actorId;

  const DirectorActorDetailScr({Key key, this.actorId}) : super(key: key);

  @override
  _DirectorActorDetailScrState createState() => _DirectorActorDetailScrState(actorId);
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
      child: Center(
        child: StreamBuilder(
          stream: _actorDetailBloc.accountInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.username, style: TextStyle(color: Colors.black));
            }

            return StreamBuilder(
              stream: _actorDetailBloc.isLoading, 
              builder: (context, snapshot) {
                return Container(
                  child: (snapshot.hasData && snapshot.data)
                      ? CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                        )
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}