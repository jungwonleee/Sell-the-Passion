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
  Map<String, bool> imageCheck = {};
  Map<String, String> feedbackMessage = {};
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
  Map<String, bool> imageCheck = {};
  Map<String, String> feedbackMessage = {};
  bool isPaid = false;
}

class User with ChangeNotifier {
  int point = 0;
}