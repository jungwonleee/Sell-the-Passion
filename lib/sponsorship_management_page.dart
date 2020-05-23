import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sell_the_passion/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:sell_the_passion/goal_provider.dart';

class SponsorshipManagementPage extends StatefulWidget {
  @override
  _SponsorshipManagementPageState createState() => _SponsorshipManagementPageState();
}

class _SponsorshipManagementPageState extends State<SponsorshipManagementPage> {
  String slave, title;

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    SlaveGoal goal = Provider.of<SlaveGoal>(context);
    DatabaseReference tmpRef = FirebaseDatabase.instance.reference().child('${fp.getUser().uid}').child("slave");
    
    tmpRef.once().then((DataSnapshot snapshot) {
      slave = snapshot.value as String;
    }).then((value) {
      DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('$slave').child("goal");
      dbRef.once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> map = snapshot.value as Map;
        title = map["title"];
        setState(() {});
      });
    });

    

    //Color mint = Theme.of(context).primaryColor;
    //Color brown = Theme.of(context).accentColor;

    

    return FutureBuilder(
      future: tmpRef.once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.hasData) {
          slave = snapshot.data.value as String;
          DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('$slave').child("goal");
          return FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                Map map = snapshot.data.value as Map<dynamic, dynamic>;
                title = map["title"];
                return Center(
                  child: Text('$title', style: TextStyle(fontSize: 20)),
                ); 
              }
              return SizedBox(height: 0);
            },
          );
        }
        return Center( child: CircularProgressIndicator() );
      },
    );
  }
}

/*
return Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text('후원할 목표가 아직 없습니다.', style: TextStyle(fontSize: 20)),
      Text('후원 매칭을 시작해보세요!', style: TextStyle(fontSize: 20))
    ],
  ),
);
*/