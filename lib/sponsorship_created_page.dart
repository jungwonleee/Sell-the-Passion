import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sell_the_passion/validate_page.dart';
import 'goal_provider.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class SponsorshipCreatedPage extends StatefulWidget {
  @override
  _SponsorshipCreatedPageState createState() => _SponsorshipCreatedPageState();
}

class _SponsorshipCreatedPageState extends State<SponsorshipCreatedPage> {
  @override
  Widget build(BuildContext context) {
    SlaveGoal goal = Provider.of<SlaveGoal>(context);
    
    TextStyle apple = TextStyle(fontSize: 15.0, fontFamily: 'Apple Semibold');
  List<String> categorystring = ['건강', '학습', '취미'];

    Color mint = Theme.of(context).primaryColor;
    Color brown = Theme.of(context).accentColor;

    DateTime now = new DateTime.now();
    DateTime startDate = goal.startDate;
    DateTime endDate = startDate.add(Duration(days: (goal.period+1)*7-1));
    int daysDiff = now.difference(startDate).inDays;
    List<String> days = ['일', '월', '화', '수', '목', '금', '토'];

    String authDayString(List<bool> authDay) {
      String s='';
      for (int i=0; i<7; i++) {
        if (authDay[i]) {
          s+=days[i];
          s+=' ';
        }
      }
      return s;
    }

    String moneyString(int money) {
      double d = money.toDouble();
      return FlutterMoneyFormatter(amount: d).output.withoutFractionDigits;
    }

    Widget goalInfo() {
      return Card (
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Column(
            children: <Widget>[
              Text(goal.title, style: TextStyle(
                fontFamily: 'Apple Semibold',
                fontSize: 28,
              ), softWrap: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
                    padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 1.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: mint, width: 1.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0)
                      )
                    ),
                    child: Text('${categorystring[goal.category]}', style: TextStyle(
                        color: mint, fontSize: 15.0, fontFamily: 'Apple Semibold')
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(12.0, 4.0, 0.0, 0.0),
                    padding: const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 1.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: mint, width: 1.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0)
                      )
                    ),
                    child: Text('${goal.period+1}주', style: TextStyle(
                        color: mint, fontSize: 15.0, fontFamily: 'Apple Semibold')
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
                      border: Border.all(color: brown, width: 2.5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0)
                      )
                    ),
                    child: Text('Day ${daysDiff+1}', style: TextStyle(
                        color: brown, fontSize: 40.0, fontFamily: 'Apple Semibold')
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
                            Text('상대가 확보한 금액', style: apple),
                            SizedBox(height: 13.0),
                            Text('내가 후원한 금액', style: apple),
                          ],
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('${moneyString(goal.currentMoney)}원', style: TextStyle(
                              fontFamily: 'Apple Semibold', fontSize: 25.0, color: brown
                            ),),
                            Text('${moneyString((goal.period+1)*4200)}원', style: TextStyle(
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
                        Text('${startDate.year}년 ${startDate.month}월 ${startDate.day}일 ~ ${endDate.year}년 ${endDate.month}월 ${endDate.day}일', style: apple)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('인증요일', style: apple),
                        SizedBox(width: 10.0),
                        Text('${authDayString(goal.authDay)}', style: apple)
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('인증방법', style: apple),
                        SizedBox(width: 10.0),
                        Flexible(
                          child: Text(goal.authMethod, style: apple, softWrap: true) ,
                        )
                      ],
                    )
                  ]
                ),
              )
            ],
          ),
        )
      );
    }

    Widget weekText(int num, String date) {
      TextStyle title = TextStyle(color: brown, fontFamily: 'Apple Semibold', fontSize: 28.0);
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
      return SizedBox(
        height: 120.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) {
            int i = week;
            int j = index;
            int startDay = 0;
            if (goal.startDate!=null) {
              startDay = goal.startDate.weekday;
            }
            var day = days[(index+startDay)%7];

            int imgIdx = i * 7 + j;
            if (goal.authImage["0$imgIdx"] != "" && goal.authImage["0$imgIdx"] != null) {
              return new Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                width:120.0,
                height:120.0,
                child: new Image.network(
                  goal.authImage["0$imgIdx"], 
                  fit: BoxFit.cover,
                  loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null ? 
                            loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  }
                ),
              );
            }

            if (goal.authDay[(j+startDay)%7]) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                width:120.0,
                height:120.0,
                color: Color(0xFFB8C6D4),
                child: Center(child: Text(day, style: TextStyle(fontFamily: 'Apple Semibold', fontSize: 30, color: Colors.white))),
              );
            }

            return SizedBox(
              width:0
            );
          }
        ),
      );
    }

    String weekDateString(DateTime weekStart, DateTime weekEnd) {
      String s='${weekStart.month}월 ${weekStart.day}일 ~ ${weekEnd.month}월 ${weekEnd.day}일';
      return s;
    }


    ListView goalRows = ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: goal.period+1,
      itemBuilder: (context, index) {
        List<Image> images = [];
        for (int j=0;j<goal.period+1;j++) {
          int imgIdx = index * 7 + j;
          if (goal.authImage["0$imgIdx"] != "" && goal.authImage["0$imgIdx"] != null) {
            images.add(new Image.network(
              goal.authImage["0$imgIdx"], 
              fit: BoxFit.cover,
              loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null ? 
                        loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              }
            ));
          } else images.add(null);
        }
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  weekText(index+1, weekDateString(startDate.add(Duration(days: 7*index)), startDate.add(Duration(days: 7*index+6)))),
                  InkWell(
                    child: Text("평가하기"), 
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ValidatePage(images);
                      }));
                    }
                  ),
                ]
              ),
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
            Expanded(
              child: Card (
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 5.0),
                  child: goalRows,
                )
              )
            ),
          ],
        )
      ),
    );
  }
}