import 'package:flutter/material.dart';

class Goal with ChangeNotifier {
  String title;
  String authMethod;
  int category;
  int period;
  int currentMoney;
  DateTime startDate;
  List<bool> authDay = [false, false, false, false, false, false, false];
  List<Map<String, String>> authImage = [];

  bool isPaid = false;

  void setGoal(String title, String authMethod, int category, int period, int currentMoney, DateTime startDate, List<bool> authDay) {
    this.title=title;
    this.authMethod=authMethod;
    this.category=category;
    this.period=period;
    this.currentMoney=currentMoney;
    this.startDate=startDate;
    this.authDay=authDay;
  }
}
