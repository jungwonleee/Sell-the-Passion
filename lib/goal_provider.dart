import 'package:flutter/material.dart';

class Goal with ChangeNotifier {
  String title;
  String authMethod;
  int category;
  int period;
  int currentMoney;
  DateTime startDate;
  List<bool> authDay;
  List<String> authImage;

  void setGoal(String title, String authMethod, int category, int period, int currentMoney, DateTime startDate, List<bool> authDay, List<String> authImage) {
    this.title=title;
    this.authMethod=authMethod;
    this.category=category;
    this.period=period;
    this.currentMoney=currentMoney;
    this.startDate=startDate;
    this.authDay=authDay;
    this.authImage=authImage;
  }
}
