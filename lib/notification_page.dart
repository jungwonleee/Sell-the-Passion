import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sell_the_passion/firebase_provider.dart';
import 'package:provider/provider.dart';

import 'validate_page.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  Widget build(BuildContext context) {

    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('${fp.getUser().uid}').child("notification");

    //Color mint = Theme.of(context).primaryColor;
    Color brown = Theme.of(context).accentColor;

    return FutureBuilder(
      future: dbRef.once(),
      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center( child: CircularProgressIndicator() );
        }
        List<dynamic> notifications = snapshot.data.value;
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            int type = notifications[index]["type"] as int;
            String text = notifications[index]["text"] as String;
            return Card(
              child: ListTile(
                leading: type==0? Icon(Icons.camera_alt, size : 50.0, color: brown) : Icon(Icons.playlist_add_check, size : 50.0, color: brown), 
                title: type==0 ? Text('인증') : Text('주간평가'),
                subtitle: Text(text),
                onTap: () {
                }
              ),
            );
          }
        );
      },
    );
  }
}