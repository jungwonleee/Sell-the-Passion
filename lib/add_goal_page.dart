import 'package:flutter/material.dart';
import 'package:sell_the_passion/goal_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_provider.dart';

class AddGoalPage extends StatefulWidget {
  @override
  _AddGoalPageState createState() => _AddGoalPageState();
}

const Color mint = Color(0xFF66A091);

class _AddGoalPageState extends State<AddGoalPage> {
  List<int> value = new List(2); // value[0]은 카테고리 값, value[1]은 period값
  List<bool> authDay = [false, false, false, false, false, false, false];
  TextEditingController goalTitleController = TextEditingController();
  TextEditingController authMethodController = TextEditingController();
  bool valid;

  @override
  void initState() {
    Goal goal = Provider.of<Goal>(context, listen: false);
    super.initState();
    setState(() {
      if (goal.title != null) {
        goalTitleController.text = goal.title;
        authMethodController.text = goal.authMethod;
        value[0] = goal.category;
        value[1] = goal.period;
        authDay = goal.authDay;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Goal goal = Provider.of<Goal>(context);
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('${fp.getUser().uid}').child("goal");

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text('목표 세우기'),
        actions: <Widget>[
          FlatButton(
            child: Text('완료', style: TextStyle(fontSize: 18, color: Colors.white)),
            onPressed: () {
              valid=isValid();
              if (valid) {
                goal.setGoal(
                  goalTitleController.text, authMethodController.text, value[0], value[1], 1234567, DateTime.now(), authDay
                );
                dbRef.update({
                  'title': goal.title,
                  'auth_method': goal.authMethod,
                  'category': goal.category,
                  'period': goal.period,
                  'auth_day': goal.authDay,
                  'auth_image': goal.authImage,
                  'is_paid': false,
                });
                Navigator.pop(context);
              }
              else {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text('오류'),
                    content: Text('모든 항목을 채워주세요.'),
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
            },
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white
            ),
            padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Text("목표명", style: TextStyle(fontSize: 20)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: mint, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      hintText: '20자 이내로 작성해주세요'
                    ),
                    cursorColor: Theme.of(context).accentColor,
                    controller: goalTitleController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Text("카테고리", style: TextStyle(fontSize: 20)),
                ),
                Wrap(
                  spacing: 10.0,
                  children: <Widget>[
                    buildChoiceChip(0, '건강', value, 0),
                    buildChoiceChip(1, '학습', value, 0),
                    buildChoiceChip(2, '취미', value, 0)
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Text("목표기간", style: TextStyle(fontSize: 20)),
                ),
                Wrap(
                  spacing: 10.0,
                  children: <Widget>[
                    buildChoiceChip(0, '1주', value, 1),
                    buildChoiceChip(1, '2주', value, 1),
                    buildChoiceChip(2, '3주', value, 1),
                    buildChoiceChip(3, '4주', value, 1),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Text("인증요일", style: TextStyle(fontSize: 20)),
                ),
                Wrap(
                  spacing: 10.0,
                  children: <Widget>[
                    buildFilterChip(0, '일'),
                    buildFilterChip(1, '월'),
                    buildFilterChip(2, '화'),
                    buildFilterChip(3, '수'),
                    buildFilterChip(4, '목'),
                    buildFilterChip(5, '금'),
                    buildFilterChip(6, '토'),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  child: Text("인증방법", style: TextStyle(fontSize: 20)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: mint, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      hintText: '한 문장으로 작성해주세요'
                    ),
                    cursorColor: Theme.of(context).accentColor,
                    controller: authMethodController,
                  ),
                ),
              ],
            ),
          )
        )
      )
    );
  }

  buildChoiceChip(int index, String label, List<int> value, int i) {
    Color labelColor = (value[i] == index) ? Colors.white : Colors.black;
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: labelColor)),
      selected: value[i] == index,
      onSelected: (bool selected) {
        setState(() {
          value[i] = selected ? index : null;
        });
      },
      selectedColor: mint,
    );
  }

  buildFilterChip(int index, String label) {
    Color labelColor = authDay[index] ? Colors.white : Colors.black;
    return FilterChip(
      label: Text(label, style: TextStyle(color: labelColor)),
      selected: authDay[index],
      onSelected: (bool selected) {
        setState(() {
          if (selected) authDay[index] = true;
          else authDay[index] = false;
        });
      },
      showCheckmark: false,
      selectedColor: mint,
    );
  }

  bool isValid() {
    bool authDayValid = false;
    if (goalTitleController.text == '') return false;
    if (authMethodController.text == '') return false;
    if (value[0] == null || value[1] == null) return false;
    for (int i=0; i<7; i++) {
      if (authDay[i] == true) authDayValid = true;
    }
    if (authDayValid == false) return false;
    return true;
  }
}