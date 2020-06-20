import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'goal_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';
import 'package:firebase_database/firebase_database.dart';

class PointTopUpPage extends StatefulWidget {
  @override
  _PointTopUpPageState createState() => _PointTopUpPageState();
}

class _PointTopUpPageState extends State<PointTopUpPage> {
  TextEditingController pointAmountController = TextEditingController();
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
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${fp.getUser().uid}');

    Widget topup(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('포인트 충전'),
          actions: <Widget>[
            key == 1 ? SizedBox(width: 0) : 
            FlatButton(
              child: Text('충전하기', style: TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () {
                int amount = int.parse(pointAmountController.text);
                if (amount <=0 || amount > 100000) {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text('오류'),
                      content: Text('올바른 금액을 입력해주세요.'),
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
                      title: Text('포인트 충전'),
                      content: Text('${FlutterMoneyFormatter(amount: amount.toDouble()).output.withoutFractionDigits}원이 결제됩니다.\n결제하시겠습니까?'),
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
                              "point" : user.point+amount
                            });
                            setState(() {
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
            children: key == 1 ? <Widget>[
              Image.asset('assets/top_up.png', height: 120, width: 120),
              SizedBox(height: 30),
              Text('포인트 충전이 완료되었습니다', style: TextStyle(fontSize: 20)),
            ] : 
            <Widget>[
              Image.asset('assets/top_up.png', height: 120, width: 120),
              SizedBox(height: 30),
              Text('충전하실 금액을 입력해주세요', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 165,
                    margin: EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: mint, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        hintText: '최대 100,000Point',
                        
                      ),
                      cursorColor: mint,
                      textAlign: TextAlign.end,
                      
                      keyboardType: TextInputType.number,
                      controller: pointAmountController,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('원', style: TextStyle(fontSize: 30))
                ],
              )
            ],
          ),
        )
      );
    }

    dbRef.child('point').once().then((DataSnapshot snapshot) {
      user.point = snapshot.value as int;
      setState(() {});
    });
    
    return FutureBuilder(
      future: dbRef.child('point').once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.hasData) user.point = snapshot.data.value as int;
        else return Center( child: CircularProgressIndicator() );
        return topup(context);
      },
    );
  }
}
