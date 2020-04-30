import 'package:flutter/material.dart';

GoalManagementPageState pageState;

class GoalManagementPage extends StatefulWidget {

  @override
  GoalManagementPageState createState() {
    pageState = GoalManagementPageState();
    return pageState;
  }
}

class GoalManagementPageState extends State<GoalManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("목표관리")
    );
  }
}