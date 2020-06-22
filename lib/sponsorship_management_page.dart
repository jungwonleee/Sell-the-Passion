import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sell_the_passion/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:sell_the_passion/goal_provider.dart';
import 'package:intl/intl.dart';
import 'package:sell_the_passion/sponsorship_created_page.dart';

class SponsorshipManagementPage extends StatefulWidget {
  @override
  _SponsorshipManagementPageState createState() => _SponsorshipManagementPageState();
}

class _SponsorshipManagementPageState extends State<SponsorshipManagementPage> {
  String slave;

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    SlaveGoal goal = Provider.of<SlaveGoal>(context);
    DatabaseReference tmpRef = FirebaseDatabase.instance.reference().child('users/${fp.getUser().uid}').child("slave");
    
    tmpRef.once().then((DataSnapshot snapshot) {
      slave = snapshot.value as String;
      return slave;
    }).then((value) {
      DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/$slave').child("goal");
      dbRef.once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> map = snapshot.value as Map;
        goal.title = map["title"];
        goal.period = map["period"];
        goal.authMethod = map["auth_method"];
        goal.authDay = List<bool>.from(map["auth_day"]);
        goal.category = map["category"];
        goal.isPaid = map["is_paid"];
        if (map['auth_image'] != null) goal.authImage = Map<String, String>.from(map['auth_image']);
        if (map['image_check'] != null) goal.imageCheck = Map<String, bool>.from(map['image_check']);
        if (map['feedback_message'] != null) goal.feedbackMessage = Map<String, String>.from(map['feedback_message']);
        goal.startDate = DateFormat('yyyy-MM-dd').parse(map["start_date"]);
        goal.currentMoney = map["current_money"];
        setState(() {});
      });
    });

    return FutureBuilder(
      future: tmpRef.once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.hasData) {
          slave = snapshot.data.value as String;
          if (slave != null && slave != fp.getUser().uid) {
            DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/$slave').child("goal");
            return FutureBuilder(
              future: dbRef.once(),
              builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                if (snapshot.hasData) {
                  Map map = snapshot.data.value as Map<dynamic, dynamic>;
                  goal.title = map["title"];
                  goal.period = map["period"];
                  goal.authMethod = map["auth_method"];
                  goal.authDay = List<bool>.from(map["auth_day"]);
                  goal.category = map["category"];
                  goal.isPaid = map["is_paid"];
                  if (map['auth_image'] != null) goal.authImage = Map<String, String>.from(map['auth_image']);
                  if (map['image_check'] != null) goal.imageCheck = Map<String, bool>.from(map['image_check']);
                  if (map['feedback_message'] != null) goal.feedbackMessage = Map<String, String>.from(map['feedback_message']);
                  goal.startDate = DateFormat('yyyy-MM-dd').parse(map["start_date"]);
                  goal.currentMoney = map["current_money"];
                  return SponsorshipCreatedPage(slave);
                }
                return SizedBox(height: 0);
              },
            );
          }
          else return Center(
            child: Text('후원할 목표가 아직 없습니다.', style: TextStyle(fontSize: 20)
            ),
          );
        }
        return Center( child: CircularProgressIndicator() );
      },
    );
  }
}