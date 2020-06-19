import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:sell_the_passion/firebase_provider.dart';
//import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//import 'validate_page.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Message> messageList = [];

  void firebaseCloudMessagingListeners() {
    FirebaseMessaging().getToken().then((token){
      print('token:'+token);
    });

    FirebaseMessaging().configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        final notification = message['notification'];
        setState(() {
          messageList.add(Message(notification['title'], notification['body']));
        });
      },

      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },

      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        final notification = message['data'];
        setState(() {
          messageList.add(Message('${notification['title']}', '${notification['body']}'));
        });
      }
    );

    FirebaseMessaging().requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true)
    );
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessagingListeners();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: messageList.length == 0 ?
        Center(
          child: Text('알림 없음', style: TextStyle(fontSize: 20))
        ) :
        ListView(
          children: messageList.map(buildMessage).toList(),
        )
    );

    /*FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${fp.getUser().uid}').child("notification");

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
    );*/
  }
}

Widget buildMessage(Message message) => Card(
  child: ListTile(
    title: Text(message.title),
    subtitle: Text(message.body),
  )
);

class Message {
  String title;
  String body;
  Message(title, body) {
    this.title = title;
    this.body = body;
  }
}