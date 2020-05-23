import 'package:flutter/material.dart';

class Goal with ChangeNotifier {
  String title;
  String authMethod;
  int category;
  int period;
  int currentMoney;
  DateTime startDate;
  List<bool> authDay = [false, false, false, false, false, false, false];
  Map<String, String> authImage = {};
  bool isPaid = false;
}

class SlaveGoal with ChangeNotifier {
  String title;
  String authMethod;
  int category;
  int period;
  int currentMoney;
  DateTime startDate;
  List<bool> authDay = [false, false, false, false, false, false, false];
  Map<String, String> authImage = {};
  bool isPaid = false;
}