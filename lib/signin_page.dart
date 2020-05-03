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

    TextStyle title = TextStyle(
      fontFamily: 'Apple Semibold',
      fontSize: 80.0,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).accentColor,
    );

    TextStyle dot = TextStyle(
      fontSize: 80.0,
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _title(title, dot),
            SizedBox(height: 20),
            _signInButton()
          ],
        )
      )
    );
  }

  Widget _title(title, dot) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 0.0),
          child: Text('Sell the', style: title),
        ),
        Container(
          padding: EdgeInsets.only(top: 65.0),
          child: Text('Passion', style: title),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(260.0, 76.0, 0.0, 0.0),
          child: Text('.', style: dot),
        )
      ],
    );
  }

  Widget _signInButton() {
    return RaisedButton(
      color: Colors.white,
      onPressed: _signInWithGoogle,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      highlightElevation: 0.0,
      elevation: 7.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                '구글 계정으로 로그인하기',
                style: TextStyle(
                  fontFamily: 'Apple Semibold',
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    await fp.signInWithGoogleAccount();
  }
}