import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySnackbar {
  static void showSnackbar(BuildContext context, String message) {
    Scaffold.of(context).hideCurrentSnackBar();

    if (message != null && message.trim().length > 0) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }
}