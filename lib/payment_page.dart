import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_provider.dart';
import 'goal_provider.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int key;

  @override
  void initState() {
    setState(() {
      key = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color mint = Theme.of(context).primaryColor;
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    User user = Provider.of<User>(context);
    Goal goal = Provider.of<Goal>(context);
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${fp.getUser().uid}');
    DatabaseReference queueRef = FirebaseDatabase.instance.reference().child('ready_queue');

    return Scaffold(
      appBar: AppBar(
        title: Text('후원금 결제'),
        actions: <Widget>[
          key == 1 ? SizedBox(width: 0) :
          FlatButton(
            child: Text('결제하기', style: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: () {
              if (user.point == null || user.point < 4200*(goal.period+1)) {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text('오류'),
                    content: Text('포인트가 부족합니다. 포인트를 충전해주세요'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('확인', style: TextStyle(color: mint),),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
              }
              else {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text('후원금 결제'),
                    content: Text('${FlutterMoneyFormatter(amount: 4200*(goal.period+1).toDouble()).output.withoutFractionDigits}p가 차감됩니다.\n결제하시겠습니까?'),
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
                          if (user.point == null) user.point = 0;
                          dbRef.update({
                            "point" : user.point-4200*(goal.period+1)
                          });
                          setState(() {
                            dbRef.update({
                              "point" : user.point-4200*(goal.period+1),
                              "user_state" : 2
                            });
                            dbRef.child('goal').update({
                              //'start_date': DateFormat('yyyy-MM-dd').format(goal.startDate),
                              'current_money': 0,
                              'is_paid': true,
                            });
                            queueRef.child('0${goal.category}').child('0${goal.period}').child(fp.getUser().uid).set(fp.getUser().uid);
                            key = 1;
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
              }
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: key == 1 ? <Widget> [
            Image.asset('assets/coffee.png', height: 120, width: 120),
            SizedBox(height: 20),
            Text('결제가 완료되었습니다', style: TextStyle(fontSize: 20)),
          ] : 
          <Widget>[
            Image.asset('assets/coffee.png', height: 120, width: 120),
            SizedBox(height: 20),
            Text('일주일에 커피 한잔의', style: TextStyle(fontSize: 20)),
            Text('금액(4,200원)이 후원됩니다', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('보유 포인트', style: TextStyle(fontSize: 20)),
            user.point != null ? Text('${FlutterMoneyFormatter(amount: user.point.toDouble()).output.withoutFractionDigits}p', style: TextStyle(fontSize: 20, color: mint)) :
            Text('0p', style: TextStyle(fontSize: 20, color: mint)),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('후원기간   ${goal.period+1}주', style: TextStyle(fontSize: 15)),
                Text('후원금액   ${FlutterMoneyFormatter(amount: 4200*(goal.period+1).toDouble()).output.withoutFractionDigits}원',style: TextStyle(fontSize: 15))
              ],
            )
          ],
        ),
      ),
    );
  }
}