import 'package:flutter/material.dart';
import 'package:sell_the_passion/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'goal_provider.dart';
import 'goal_created_page.dart';
import 'add_goal_page.dart';
import 'dart:async';

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
    for (int i=1; i<=7; i++) {
      if (authDay[i%7]==true) {
        switch(i%7) {
          case 1: s+="월 "; break;
          case 2: s+="화 "; break;
          case 3: s+="수 "; break;
          case 4: s+="목 "; break;
          case 5: s+="금 "; break;
          case 6: s+="토 "; break;
          case 0: s+="일 "; break;
        }
      }
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${fp.getUser().uid}');
    DatabaseReference queueRef = FirebaseDatabase.instance.reference().child('ready_queue');
    Goal goal = Provider.of<Goal>(context);

    Color mint = Theme.of(context).primaryColor;
    Color brown = Theme.of(context).accentColor;

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

    if (goal.title != null && goal.isPaid == false) {
      widgetList.clear();
      widgetList += <Widget>[
        Container(
          width: MediaQuery.of(context).size.width*0.8,
          child: Text('${goal.title}', style: TextStyle(fontSize: 28), textAlign: TextAlign.center),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 0.0),
              padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 1.0),
              decoration: BoxDecoration(
                border: Border.all(color: brown, width: 1.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0)
                )
              ),
              child: Text('${categoryString(goal.category)}', style: TextStyle(
                  color: brown, fontSize: 15.0)
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 0.0),
              padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 1.0),
              decoration: BoxDecoration(
                border: Border.all(color: brown, width: 1.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0)
                )
              ),
              child: Text('${goal.period+1}주', style: TextStyle(
                  color: brown, fontSize: 15.0)
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width*0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('인증요일   ${authDayString(goal.authDay)}', style: TextStyle(fontSize: 15)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text('인증방법', style: TextStyle(fontSize: 15)),
                SizedBox(width: 12),
                Flexible(
                  child: Text('${goal.authMethod}', style: TextStyle(fontSize: 15), softWrap: true)
                ),
              ]),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              color: brown,
              icon: Icon(Icons.edit),
              iconSize: 30.0,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return AddGoalPage();
                }));
              }
            ),
            RaisedButton(
              color: Colors.white,
              elevation: 7.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              child: Text('후원 매칭하기', style: TextStyle(fontSize: 15, color: mint)),
              onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    content: Text('매칭을 신청하시겠습니까?'),
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
                          goal.startDate = DateTime.now();
                          setState(() {
                            dbRef.child('goal').update({
                              //'start_date': DateFormat('yyyy-MM-dd').format(goal.startDate),
                              'current_money': 0,
                              'is_paid': true,
                            });
                            dbRef.update({
                              'user_state': 2
                            });
                            queueRef.child('0${goal.category}').child('0${goal.period}').child(fp.getUser().uid).set(fp.getUser().uid);
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
              }
            ),
            IconButton(
              color: brown,
              icon: Icon(Icons.delete),
              iconSize: 30.0,
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
                            dbRef.update({
                              'user_state': 0
                            });
                            dbRef.child('goal').remove();
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
    else if (goal.isPaid == true) {
      widgetList.clear();
      DateTime now = new DateTime.now();
      DateTime nine = new DateTime(now.year, now.month, now.day, 21);
      if (now.hour > 21) nine.add(Duration(days: 1));
      int restseconds = nine.difference(now).inSeconds;
      Timer timer;
      if (timer == null) {
        timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
          setState(() {
            restseconds = restseconds - 1;
          });
        });
      }
      int seconds = restseconds % 60;
      int minutes = restseconds % 3600 ~/ 60;
      int hours = restseconds ~/ 3600;
      widgetList += <Widget>[
        Text('매칭신청이 완료되었습니다.', style: TextStyle(fontSize: 20)),
        Text('매칭은 매일 21시에 이루어집니다.', style: TextStyle(fontSize: 20)),
        SizedBox(height: 50),
        Text('매칭까지 남은 시간', style: TextStyle(fontSize: 20)),
        Text('$hours시간 $minutes분 $seconds초', style: TextStyle(fontSize: 40)),
        RaisedButton(
          color: Colors.white,
          elevation: 7.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          child: Text('매칭 취소하기', style: TextStyle(fontSize: 15, color: mint)),
          onPressed: () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                content: Text('매칭을 취소하시겠습니까?'),
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
                        dbRef.child('goal').update({
                          //'start_date': DateFormat('yyyy-MM-dd').format(goal.startDate),
                          'current_money': 0,
                          'is_paid': false,
                        });
                        dbRef.update({
                          'user_state': 1
                        });
                        queueRef.child('0${goal.category}').child('0${goal.period}').child(fp.getUser().uid).remove();
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
          }
        ),
      ];
    }

    dbRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value as Map;
      if (map!=null && map['user_state'] != 0) {
        Map<dynamic, dynamic> map2 = map['goal'] as Map;
        goal.title = map2["title"];
        goal.period = map2["period"];
        goal.authMethod = map2["auth_method"];
        goal.authDay = List<bool>.from(map2["auth_day"]);
        goal.category = map2["category"];
        if(map['user_state'] >= 2) goal.isPaid = map2["is_paid"];
        else goal.isPaid = false;
        if (map['user_state'] < 3) goal.startDate = null;
      } else {
        goal.title = null;
        goal.period = null;
        goal.authMethod = null;
        goal.authDay = [false, false, false, false, false, false, false];
        goal.category = null;
        goal.isPaid = false;
        goal.startDate = null;
      }

      if (map != null && map['user_state'] == 3) {
        Map<dynamic, dynamic> map2 = map['goal'] as Map;
        if (map2['auth_image'] != null)
          goal.authImage = Map<String, String>.from(map2['auth_image']);
        goal.startDate = DateFormat('yyyy-MM-dd').parse(map2['start_date']);
        goal.currentMoney = map2['curret_money'];
      }
      setState(() {});
    });

    return FutureBuilder(
      future: dbRef.once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.value as Map;
          if (map != null && map['user_state'] != 0) {
            Map<dynamic, dynamic> map2 = map['goal'] as Map;
            goal.title = map2["title"];
            goal.period = map2["period"];
            goal.authMethod = map2["auth_method"];
            goal.authDay = List<bool>.from(map2["auth_day"]);
            goal.category = map2["category"];
            if(map['user_state'] >= 2) goal.isPaid = map2["is_paid"];
            else goal.isPaid = false;
            if (map['user_state'] < 3) goal.startDate = null;
          } else {
            goal.title = null;
            goal.period = null;
            goal.authMethod = null;
            goal.authDay = [false, false, false, false, false, false, false];
            goal.category = null;
            goal.isPaid = false;
            goal.startDate = null;
          }

          if (map != null && map['user_state'] == 3) {
            Map<dynamic, dynamic> map2 = map['goal'] as Map;
            if (map2['auth_image'] != null)
              goal.authImage = Map<String, String>.from(map2['auth_image']);
            goal.startDate = DateFormat('yyyy-MM-dd').parse(map2['start_date']);
            goal.currentMoney = map2['current_money'];
            return GoalCreatedPage();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgetList,
            )
          );
        }
        return Center( child: CircularProgressIndicator() );
      }
    );
  }
}