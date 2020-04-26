import 'package:flutter/material.dart';
import 'firebase_provider.dart';
import 'package:provider/provider.dart';

SignInPageState pageState;

class SignInPage extends StatefulWidget {
  @override
  SignInPageState createState() {
    pageState = SignInPageState();
    return pageState;
  }
}

class SignInPageState extends State<SignInPage> {
  FirebaseProvider fp;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    logger.d(fp.getUser());

    void _signInWithGoogle() async {
      await fp.signInWithGoogleAccount();
    }

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
              color: Colors.white,
              elevation: 5.0,
              child: GestureDetector(
                onTap: _signInWithGoogle,
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