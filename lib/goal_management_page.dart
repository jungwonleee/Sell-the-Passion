import 'package:flutter/material.dart';
import 'goal_provider.dart';
import 'package:provider/provider.dart';
import 'add_goal.dart';

class GoalManagementPage extends StatefulWidget {
  @override
  _GoalManagementPageState createState() => _GoalManagementPageState();
}

class _GoalManagementPageState extends State<GoalManagementPage> {
  
  String categoryString(int c) {
    String s="";
    switch(c) {
      case 0: s='건강'; break;
      case 1: s='학습'; break;
      case 2: s='취미'; break;
    }
    return s;
  }

  String authDayString(List<bool> authDay) {
    String s="";
    for (int i=0; i<7; i++) {
      if (authDay[i]==true) {
        switch(i) {
          case 0: s+="월 "; break;
          case 1: s+="화 "; break;
          case 2: s+="수 "; break;
          case 3: s+="목 "; break;
          case 4: s+="금 "; break;
          case 5: s+="토 "; break;
          case 6: s+="일 "; break;
        }
      }
    }
    return s;
  }
  
  @override
  Widget build(BuildContext context) {
    Goal goal = Provider.of<Goal>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          (goal.title!=null?
            <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('목표명: ${goal.title}', style: TextStyle(fontSize: 20)),
                  Text('카테고리: ${categoryString(goal.category)}', style: TextStyle(fontSize: 20)),
                  Text('목표기간: ${goal.period+1}주', style: TextStyle(fontSize: 20)),
                  Text('인증요일: ${authDayString(goal.authDay)}', style: TextStyle(fontSize: 20)),
                  Text('인증방법: ${goal.authMethod}', style: TextStyle(fontSize: 20)),
                ],
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('목표 지우기'),
                onPressed: () {
                  setState(() {
                    goal.title=null;
                  });
                }
              ),
            ] : <Widget>[
              RaisedButton(
                child: Text('목표 만들기'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AddGoal();
                  }));
                }
              ),
            ]
          )
        ),
      )
    );
  }
}