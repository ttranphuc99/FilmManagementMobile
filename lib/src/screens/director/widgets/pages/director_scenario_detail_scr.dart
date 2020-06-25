import 'package:flutter/material.dart';

class DirectorScenarioDetail extends StatefulWidget {
  @override
  _DirectorScenarioDetailState createState() => _DirectorScenarioDetailState();
}

class _DirectorScenarioDetailState extends State<DirectorScenarioDetail> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 32),
            child: Center(
              child: Column(
                children: [
                  _buildTitle()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Center(
      child: Container(
        child: Text(
          "Scenario Detail",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
        ),
      ),
    );
  }
}
