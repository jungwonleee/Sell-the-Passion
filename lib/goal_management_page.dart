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

class GoalManagementPageState extends State<GoalManagementPage> {
  List<String> urls = [""];

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);

    FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
    DatabaseReference dbRef = _firebaseDatabase.reference().child("${fp.getUser().uid}").child("posts");

    void getPhotosFromDB() {
      dbRef.once().then((DataSnapshot snapshot){
        Map<dynamic, dynamic> values = snapshot.value;
        urls.clear();
        values.forEach((key, value) {
          setState(() {
            urls.add(value);
          });
        });
      });
    }

    getPhotosFromDB();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.network(
              urls.first,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                if (loadingProgress == null)
                  return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
          ),
          FlatButton(
            child: Text("Refresh"),
            onPressed: getPhotosFromDB,
          ),
        ],
      ),
    );
  }
}