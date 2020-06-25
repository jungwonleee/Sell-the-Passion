import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:provider/provider.dart';
import 'package:sell_the_passion/goal_provider.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CardSwipePage extends StatefulWidget {
  final String slave;
  CardSwipePage(this.slave);

  @override
  _CardSwipePageState createState() => _CardSwipePageState();
}

class _CardSwipePageState extends State<CardSwipePage> with TickerProviderStateMixin {
  List<CardImage> cardImages = [];
  int key;
  TextEditingController feedbackMessageController = TextEditingController();
  Color brown = Color(0xFF776D61);

  void initCard() {
    SlaveGoal goal = Provider.of<SlaveGoal>(context, listen: false);
    DateTime now = new DateTime.now();
    DateTime startDate = goal.startDate;
    int index = (now.difference(startDate).inDays).toInt()~/7-1;
    for (int j=0; j<7; j++) {
      int imgIdx = index*7+j;
      if (!goal.authDay[(j+startDate.weekday)%7]) continue;
      if (goal.authImage["0$imgIdx"] != "" && goal.authImage["0$imgIdx"] != null) {
        cardImages.add(CardImage(new Image.network(
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
        ), imgIdx, null));
      } else cardImages.add(CardImage(null, imgIdx, false));
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      key = 0;
      initCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    CardController controller = CardController();
    SlaveGoal goal = Provider.of<SlaveGoal>(context);
    DateTime now = new DateTime.now();
    DateTime startDate = goal.startDate;
    int week = (now.difference(startDate).inDays).toInt()~/7;
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${widget.slave}').child("goal");

    List<Widget> cardSwipe = [
      Text('인증이 제대로 되었다면 오른쪽으로\n그렇지 않다면 왼쪽으로 넘겨주세요', style: TextStyle(fontSize: 20),),
      Container(
        height: MediaQuery.of(context).size.height*0.6,
        child: new TinderSwapCard(
          orientation: AmassOrientation.BOTTOM,
          totalNum: cardImages.length,
          stackNum: cardImages.length,
          swipeEdge: 4.0,
          maxWidth: MediaQuery.of(context).size.width*0.9,
          maxHeight: MediaQuery.of(context).size.width*0.9,
          minWidth: MediaQuery.of(context).size.width*0.8,
          minHeight: MediaQuery.of(context).size.width*0.8,
          cardBuilder: (context, index) => Card(
            child: cardImages[index].image != null ? cardImages[index].image
            : Center(child: Text('인증사진이 없습니다.\n왼쪽으로 넘겨주세요', style: TextStyle(fontSize: 20),))
          ),
          cardController: controller,
          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
            if (orientation == CardSwipeOrientation.LEFT) {
              setState(() {
                cardImages[index].approved = false;
              });
            }
            else {
              setState(() {
                cardImages[index].approved = true;
              });
            }
            if (index == cardImages.length-1) {
              setState(() {
                key = 1;
              });
            }
          },
        ),
      ),
    ];

    List<Widget> result = [
      //Text('${cardImages[0].approved}\n${cardImages[1].approved}\n${cardImages[2].approved}\n${cardImages[3].approved}', style: TextStyle(fontSize: 20),)
      Text('일주일간의 인증과정에 대해\n피드백 메시지를 남겨주세요', style: TextStyle(fontSize: 20),),
      SizedBox(height: 30),
      Container(
        width: MediaQuery.of(context).size.width*0.9,
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: brown, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
            hintText: '따뜻한 응원의 한마디도 좋아요'
          ),
          cursorColor: brown,
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          controller: feedbackMessageController,
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text('$week주차 주간평가'),
        actions: <Widget>[
          key == 1 ? FlatButton(
            child: Text('완료', style: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: () async {
              if (feedbackMessageController.text == "") {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text('오류'),
                    content: Text('피드백 메시지를 남겨주세요.'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('확인', style: TextStyle(color: brown),),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
              }
              else {
                int approvedNum = 0;
                for (int i=0; i<cardImages.length; i++) {
                  if (cardImages[i].approved == true) approvedNum += 1; 
                  dbRef.child('image_check').update(
                    {"0${cardImages[i].index}": cardImages[i].approved}
                  );
                }
                dbRef.child('feedback_message').update(
                  {"0${week-1}": feedbackMessageController.text}
                );
                dbRef.update(
                  {"current_money": goal.currentMoney += 4200*approvedNum ~/ cardImages.length}
                );

              try {
                final HttpsCallable notificate = CloudFunctions.instance.getHttpsCallable(functionName: 'notificate')
                ..timeout = const Duration(seconds: 30);
                await notificate.call(
                  <String, dynamic> {
                    "to": widget.slave,
                    "type": "1",
                    "title": "후원자가 평가를 완료하였습니다.",
                    "body": "목표관리화면에서 평가내용을 확인해주세요.",
                  }
                );
              } on CloudFunctionsException catch (e) {
                print('caught firebase functions exception');
                print('code: ${e.code}');
                print('message: ${e.message}');
                print('details: ${e.details}');
              } catch (e) {
                print('caught generic exception');
                print(e);
              }

                Navigator.pop(context);
              }
            }
          ) : SizedBox(width: 0),
        ]
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: key == 0 ? cardSwipe : result,
        ),
      ),
    );
  }
}

class CardImage {
  Image image;
  int index;
  bool approved;

  CardImage(image, index, approved) {
    this.image = image;
    this.index = index;
    this.approved = approved;
  }
}