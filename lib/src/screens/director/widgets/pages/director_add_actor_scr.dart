import 'package:flutter/material.dart';

class DirectorAddActorScr extends StatefulWidget {
  @override
  _DirectorAddActorScrState createState() => _DirectorAddActorScrState();
}

class _DirectorAddActorScrState extends State<DirectorAddActorScr> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Container(
        child: Column(
          children: [
            _buildTitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Text(
        "Add new actor",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
