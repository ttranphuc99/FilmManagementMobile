import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:film_management/src/models/notification.dart';

class NotiBloc {
  final BuildContext context;

  NotiBloc(this.context);

  PublishSubject<MyNotification> _stream = PublishSubject<MyNotification>();

  Observable<MyNotification> get stream => _stream.stream;

  void close() {
    _stream.close();
  }

  void addNoti(Map<String, dynamic> message) async {
    var jsonNoti = message['notification'];
    print(jsonNoti['title']);
    print(jsonNoti['body']);

    MyNotification noti = MyNotification(title: jsonNoti['title'], content: jsonNoti['body']);
    _stream.sink.add(noti);
    await Future.delayed(Duration(seconds: 5));
    noti.isShow = false;
    _stream.sink.add(noti);
  }
}