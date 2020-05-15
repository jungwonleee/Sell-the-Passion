import 'package:flutter/material.dart';
import 'package:sell_the_passion/firebase_provider.dart';
import 'goal_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'goal_created_page.dart';
import 'add_goal_page.dart';
import 'package:intl/intl.dart';

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
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('${fp.getUser().uid}').child("goal");
    Goal goal = Provider.of<Goal>(context);

    List<Widget> widgetList = <Widget>[
      Text('등록된 목표가 아직 없습니다.', style: TextStyle(fontSize: 20)),
      Text('새로운 목표를 세워보세요!', style: TextStyle(fontSize: 20)),
      SizedBox(height: 20),
      RaisedButton(
        color: Colors.white,
        elevation: 7.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Text('목표 세우기', style: TextStyle(fontSize: 15, color: mint)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return AddGoalPage();
          }));
        }
      ),
    ];

    if (goal.title != null) {
      widgetList.clear();
      widgetList += <Widget>[
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Colors.white,
              elevation: 7.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              child: Text('목표 수정하기', style: TextStyle(fontSize: 15, color: mint)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return AddGoalPage();
                }));
              }
            ),
            SizedBox(width: 25),
            RaisedButton(
              color: Colors.white,
              elevation: 7.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              child: Text('목표 삭제하기', style: TextStyle(fontSize: 15, color: mint)),
              onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    content: Text('목표를 삭제하시겠습니까?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('취소', style: TextStyle(color: mint),),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('확인', style: TextStyle(color: mint),),
                        onPressed: () {
                          setState(() {
                            dbRef.remove();
                            goal.title=null;
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
              }
            ),
            SizedBox(width: 25),
            RaisedButton(
              color: Colors.white,
              elevation: 7.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              child: Text('결제', style: TextStyle(fontSize: 15, color: mint)),
              onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    content: Text('목표를 결제하시겠습니까?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('취소', style: TextStyle(color: mint),),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('확인', style: TextStyle(color: mint),),
                        onPressed: () {
                          goal.isPaid = true;
                          goal.startDate = (new DateFormat('yyyy-MM-dd')).format(DateTime.now());
                          setState(() {
                            dbRef.update({
                              'is_paid': true,
                              'start_date': goal.startDate,
                              'current_money': 0,
                            });
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
              }
            ),
          ],
        ),
      ];
    }

    dbRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value as Map;
      if (map != null) {
        goal.title = map["title"];
        goal.period = map["period"];
        goal.authMethod = map["auth_method"];
        goal.authDay = List<bool>.from(map["auth_day"]);
        if (map["auth_image"] != null)
          goal.authImage = Map<String, String>.from(map["auth_image"]);
        goal.category = map["category"];
        goal.isPaid = map["is_paid"];
        goal.startDate = map["start_date"];
        goal.currentMoney = map["current_money"];
      }
      setState(() {});
    });

    if (goal != null && goal.isPaid != null && goal.isPaid)
      return GoalCreatedPage();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widgetList,
      )
    );
  }
}