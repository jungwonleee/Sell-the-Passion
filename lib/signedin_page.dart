import 'package:flutter/material.dart';
import 'firebase_provider.dart';
import 'package:provider/provider.dart';

SignedInPageState pageState;

class SignedInPage extends StatefulWidget {
  @override
  SignedInPageState createState() {
    pageState = SignedInPageState();
    return pageState;
  }
}

class SignedInPageState extends State<SignedInPage> {
  FirebaseProvider fp;
  TextStyle applesb =const TextStyle(fontFamily: 'Apple Semibold');

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome", style: applesb),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout', style: applesb),
            onPressed: fp.signOut,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(fp.getUser().photoUrl),
            ),
            SizedBox(height: 20),
            Text(fp.getUser().displayName, style: TextStyle(fontFamily: 'Apple Semibold',fontSize: 30)),
          ],
        ),
      )
    );
  }
}