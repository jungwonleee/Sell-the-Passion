import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sell_the_passion/add_goal_page.dart';
import 'firebase_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'goal_provider.dart';
import 'package:intl/intl.dart';

MyPageState pageState;

class MyPage extends StatefulWidget {
  @override
  MyPageState createState() {
    pageState = MyPageState();
    return pageState;
  }
}

class MyPageState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    Color brown = Theme.of(context).accentColor;

    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    User user = Provider.of<User>(context);
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${fp.getUser().uid}');

    Widget myInfo() {
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);

      return Card(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Column(
            children: <Widget>[
              CircleAvatar(radius: 50,backgroundImage: NetworkImage(fp.getUser().photoUrl)),
              Text(fp.getUser().displayName, style: TextStyle(fontSize: 28), softWrap: true),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(  
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('${user.totalGoalNum}', style: TextStyle(fontSize: 30)),
                        SizedBox(height: 5.0),
                        Text('세운 목표 수', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                  Container(  
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('${user.successGoalNum}', style: TextStyle(fontSize: 30)),
                        SizedBox(height: 5.0),
                        Text('성공한 목표 수', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(  
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        user.point != null ? Text('${FlutterMoneyFormatter(amount: user.point.toDouble()).output.withoutFractionDigits}p', style: TextStyle(fontSize: 30, color: mint)) :
                        Text('0p', style: TextStyle(fontSize: 30, color: mint)),
                        SizedBox(height: 5.0),
                        Text('보유 포인트', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                  Container(  
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('${FlutterMoneyFormatter(amount: user.notRefundedMoney.toDouble()).output.withoutFractionDigits}원', style: TextStyle(fontSize: 30)),
                        SizedBox(height: 5.0),
                        Text('미환급 금액', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget historyInfo(String title, int currentMoney, int period, int category, DateTime startDate, DateTime endDate, String authMethod) {
      return Card(
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("$title", style: TextStyle(
                fontFamily: 'Apple Semibold',
                fontSize: 20,
              ), softWrap: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('확보한 금액   ${FlutterMoneyFormatter(amount: currentMoney.toDouble()).output.withoutFractionDigits}원', style: TextStyle(fontSize: 15)),
                  SizedBox(width: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                        padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 1.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: brown, width: 1.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0)
                          )
                        ),
                        child: Text(['건강', '학습', '취미'][category], style: TextStyle(
                            color: brown, fontSize: 15.0)
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
                        child: Text('${period+1}주', style: TextStyle(
                            color: brown, fontSize: 15.0)
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 2),
              Text('목표기간   ${startDate.year}년 ${startDate.month}월 ${startDate.day}일 ~ ${endDate.year}년 ${endDate.month}월 ${endDate.day}일', style: TextStyle(fontSize: 15)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text('인증방법', style: TextStyle(fontSize: 15)),
                SizedBox(width: 12),
                Flexible(
                  child: Text('$authMethod', style: TextStyle(fontSize: 15), softWrap: true)
                ),
              ]),
            ],
          ),
        ),
      );
    }

    /*ListView historyRows = ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 1,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: [
              historyInfo(),     
            ]
          )
        );
      }
    );*/

    dbRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value as Map;
      user.totalGoalNum = map['total_goal_num'];
      user.successGoalNum = map['success_goal_num'];
      user.point = map['point'];
      user.notRefundedMoney = map['not_refunded_money'];
      setState(() {});
    });
    
    return FutureBuilder(
      future: dbRef.once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (!snapshot.hasData) return Center( child: CircularProgressIndicator() );
        Map<dynamic, dynamic> map = snapshot.data.value as Map;
        user.totalGoalNum = map['total_goal_num'];
        user.successGoalNum = map['success_goal_num'];
        user.point = map['point'];
        user.notRefundedMoney = map['not_refunded_money'];
        Map<dynamic, dynamic> history = map['history'];
        List<dynamic> keyList = [];
        if (history != null) keyList = history.keys.toList();
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                myInfo(),
                Expanded(
                  child: history == null ? Center(child: Text('과거 목표 없음', style: TextStyle(fontSize: 20))): Container(
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        Map<dynamic, dynamic> goal = history[keyList[index]];
                        String title = goal['title'];
                        int currentMoney = goal['current_money'];
                        int period = goal['period'];
                        int category = goal['category'];
                        DateTime startDate = DateFormat('yyyy-MM-dd').parse(goal['start_date']);
                        DateTime endDate = startDate.add(Duration(days: (period+1)*7-1));
                        String authMethod = goal['auth_method'];
                        return Container(
                          child: Column(
                            children: [
                              historyInfo(title, currentMoney, period, category, startDate, endDate, authMethod),     
                            ]
                          )
                        );
                      },
                    ),
                  )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}