import 'package:flutter/material.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void login() async {
    try {
      await widget.auth.signInWithGoogle();
      widget.onSignedIn();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(30.0, 125.0, 0.0, 0.0),
                  child: Text(
                    'Sell the',
                    style: TextStyle(
                        fontFamily: 'Apple Semibold',
                        fontStyle: FontStyle.normal,
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30.0, 190.0, 0.0, 0.0),
                  child: Text(
                    'Passion',
                    style: TextStyle(
                        fontFamily: 'Apple Semibold',
                        fontStyle: FontStyle.normal,
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(290.0, 203.0, 0.0, 0.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[400]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 75.0),
          Container(
            padding: EdgeInsets.only(left: 60.0, right: 60.0),
            height: 40.0,
            child: Material(
              borderRadius: BorderRadius.circular(7.0),
              //shadowColor: Colors.grey,
              color: Colors.white,
              elevation: 5.0,
              child: GestureDetector(
                onTap: login,
                child: Center(
                  child: Text(
                    '구글 계정으로 로그인하기',
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'Apple Semibold'),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
