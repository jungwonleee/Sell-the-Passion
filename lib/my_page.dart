import 'package:flutter/material.dart';
import 'firebase_provider.dart';
import 'package:provider/provider.dart';

MyPageState pageState;

class MyPage extends StatefulWidget {
  @override
  MyPageState createState() {
    pageState = MyPageState();
    return pageState;
  }
}

class MyPageState extends State<MyPage> {
  static const TextStyle mainText = TextStyle(fontFamily: 'Apple Semibold', fontSize: 30);
  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(fp.getUser().photoUrl),
          ),
          SizedBox(height: 20),
          Text(fp.getUser().displayName, style: mainText),
          Text('마이페이지', style: mainText)
        ],
      ),
    );
  }
}