import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';

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
                        Text('10', style: TextStyle(fontSize: 30)),
                        SizedBox(height: 5.0),
                        Text('세운 목표 수', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                  Container(  
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('5', style: TextStyle(fontSize: 30)),
                        SizedBox(height: 5.0),
                        Text('성공한 목표 수', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                  Container(  
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('3,000원', style: TextStyle(fontSize: 30)),
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

    Widget historyInfo() {
      return Card(
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("아침 30분 조깅", style: TextStyle(
                fontFamily: 'Apple Semibold',
                fontSize: 20,
              ), softWrap: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('확보한 금액   12,600원', style: TextStyle(fontSize: 15)),
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
                        child: Text('건강', style: TextStyle(
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
                        child: Text('3주', style: TextStyle(
                            color: brown, fontSize: 15.0)
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 2),
              Text('목표기간   2020년 3월 15일 ~ 2020년 4월 3일', style: TextStyle(fontSize: 15)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Text('인증방법', style: TextStyle(fontSize: 15)),
                SizedBox(width: 12),
                Flexible(
                  child: Text('조깅 후 운동복 차림의 모습을 찍는다.조깅 후 운동복 차림의 모습을 찍는다.', style: TextStyle(fontSize: 15), softWrap: true)
                ),
              ]),
            ],
          ),
        ),
      );
    }

    ListView historyRows = ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: [
              historyInfo(),     
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
            myInfo(),
            Expanded(
              child: Container(
                child: historyRows,
              )
            ),
          ],
        ),
      ),
    );
  }
}