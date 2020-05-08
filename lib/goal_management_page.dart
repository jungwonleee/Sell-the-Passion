import 'package:provider/provider.dart';

import 'firebase_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

GoalManagementPageState pageState;

class GoalManagementPage extends StatefulWidget {

  @override
  GoalManagementPageState createState() {
    pageState = GoalManagementPageState();
    return pageState;
  }
}

class Goal {
  String title;
  List<int> auth_day;
  List<String> auth_img;
  String auth_method;
  String category;
  String current_money;
  int period;
}

class GoalManagementPageState extends State<GoalManagementPage> {
  TextStyle apple = TextStyle(fontSize: 15.0, fontFamily: 'Apple Semibold');
  Goal goal = Goal();

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
    DatabaseReference dbRef = _firebaseDatabase.reference().child("${fp.getUser().uid}").child("goal");

    dbRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value as Map;
      setState( () { 
        goal.title = map["title"];
        goal.period = map["period"];
        goal.auth_method = map["auth_method"];
        goal.auth_day = List<int>.from(map["auth_day"]);
        goal.auth_img = List<String>.from(map["auth_img"]);
      });
    });

    Color mint = Theme.of(context).primaryColor;
    Color brown = Theme.of(context).accentColor;

    Widget goalInfo() {
      return Container(
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.white
        ),
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(goal.title, style: TextStyle(
                  fontFamily: 'Apple Semibold',
                  fontSize: 28
                ),),
                Container(
                  margin: const EdgeInsets.fromLTRB(12.0, 4.0, 0.0, 0.0),
                  padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 1.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: brown, width: 1.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0)
                    )
                  ),
                  child: Text('건강', style: TextStyle(
                      color: brown, fontSize: 15.0, fontFamily: 'Apple Semibold')
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(12.0, 4.0, 0.0, 0.0),
                  padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 1.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: brown, width: 1.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0)
                    )
                  ),
                  child: Text('${goal.period}주', style: TextStyle(
                      color: brown, fontSize: 15.0, fontFamily: 'Apple Semibold')
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: mint, width: 2.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0)
                    )
                  ),
                  child: Text('Day 5', style: TextStyle(
                      color: mint, fontSize: 40.0, fontFamily: 'Apple Semibold')
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(height: 2.0),
                          Text('확보한 금액', style: apple),
                          SizedBox(height: 13.0),
                          Text('후원받은 금액', style: apple),
                        ],
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text('3,000원', style: TextStyle(
                            fontFamily: 'Apple Semibold', fontSize: 25.0, color: mint
                          ),),
                          Text('16,800원', style: TextStyle(
                            fontFamily: 'Apple Semibold', fontSize: 25.0
                          ),),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('목표기간', style: apple),
                      SizedBox(width: 10.0),
                      Text('2020년 4월 6일 ~ 2020년 5월 3일', style: apple)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('인증횟수', style: apple),
                      SizedBox(width: 10.0),
                      Text('매일', style: apple)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('인증방법', style: apple),
                      SizedBox(width: 10.0),
                      Text(goal.auth_method, style: apple)
                    ],
                  )
                ]
              ),
            )
          ],
        ),
      );
    }

    Widget weekText(int num, String date) {
      TextStyle title = TextStyle(color: mint, fontFamily: 'Apple Semibold', fontSize: 28.0);
      TextStyle body = TextStyle(color: Colors.black, fontFamily: 'Apple Semibold', fontSize: 15.0);

      return RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: '$num주차', style: title),
            TextSpan(text: '   $date', style: body)
          ]
        )
      );
    }

    Widget weekImage(int week) {
      List<String> days = [
        '월', '화', '수', '목', '금', '토', '일'
      ];


      int num = 0;
      if (goal.auth_day != null) {
        List<String> _days = [];
        for(int i=0;i<7;i++) {
          if (goal.auth_day[i] == 1) {
            _days.add(days[i]);
            num++;
          }
        }
        days = _days;
      }
      return SizedBox(
        height: 120.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: num,
          itemExtent: 128.0,
          itemBuilder: (context, index) {
            var day = days[index];

            int img_idx = num*week+index;
            if (img_idx < goal.auth_img.length) {
              if (goal.auth_img[img_idx] != "" && goal.auth_img[img_idx] != null) {
                return Image.network(goal.auth_img[img_idx]);
              }
            }

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 3.0),
              color: Color(0xFFB8C6D4),
              child: Center(child: Text(day, style: TextStyle(fontFamily: 'Apple Semibold', fontSize: 30, color: Colors.white))),
            );
          }
        ),
      );
    }

    ListView goalRows = ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: goal.period,
      itemExtent: 180.0,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              weekText(index+1, '4월 6일 ~ 4월 12일'),
              SizedBox(height: 8),
              weekImage(index),
              SizedBox(height: 10),
            ]
          )
        );
      }
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            goalInfo(),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white
                ),
                padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 5.0),
                child: goalRows,
              )
            ),
          ],
        )
      ),
    );
  }
}