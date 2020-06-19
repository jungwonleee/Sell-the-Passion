import 'package:flutter/material.dart';
/*import 'package:firebase_database/firebase_database.dart';
import 'package:sell_the_passion/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';*/

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  /*List<Message> messageList;

  void firebaseCloudMessagingListeners() {
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${fp.getUser().uid}');

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
    firebaseCloudMessagingListeners();
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {

    /*return Scaffold(
      body: messageList.length == 0 ?
        Center(
          child: Text('알림 없음', style: TextStyle(fontSize: 20))
        ) :
        ListView(
          children: messageList.map(buildMessage).toList(),
        )
    );*/
    List<dynamic> messageList = [
      {
        "type" : 0,
        "title" : "매칭 완료",
        "body" : "매칭이 완료되었습니다. 후원 목표를 확인해주세요."
      },
      {
        "type" : 1,
        "title" : "인증하기",
        "body" : "오늘은 인증하는 날입니다. 늦지 않게 인증을 완료해주세요"
      },
      {
        "type" : 2,
        "title" : "주간 평가",
        "body" : "오늘은 주간 평가 날입니다. 후원하는 목표를 평가해주세요."
      },
      {
        "type" : 2,
        "title" : "평가 완료",
        "body" : "후원자가 평가를 완료하였습니다. 평가 내용을 확인해주세요."
      },
    ];

    Color brown = Theme.of(context).accentColor;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView.builder(
        itemCount: messageList.length,
        itemBuilder: (context, index) {
          int type = messageList[index]["type"] as int;
          String title = messageList[index]["title"] as String;
          String body = messageList[index]["body"] as String;
          return Card(
            child: ListTile(
              leading:  type == 0 ? Icon(Icons.supervisor_account, size: 50, color: brown) :
              type == 1 ? Icon(Icons.camera_alt, size: 50, color: brown) : Icon(Icons.playlist_add_check, size: 50, color: brown),
              title: Text(title),
              subtitle: Text(body),
            ),
          );
        },
      )
    );
  }
}

/*Widget buildMessage(Message message) => Card(
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
}*/