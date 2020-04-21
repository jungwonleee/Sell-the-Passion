import 'package:flutter/material.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId =
            await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Sign in: $userId');
        } else {
          String userId =
            await widget.auth.createUserWithEmailAndPassword(_email, _password);
          print('Registered user: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(30.0, 60.0, 0.0, 0.0),
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
                  padding: EdgeInsets.fromLTRB(30.0, 125.0, 0.0, 0.0),
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
                  padding: EdgeInsets.fromLTRB(290.0, 138.0, 0.0, 0.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[400]),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 30.0, right: 30.0),
            child: new Form(
                key: formKey,
                child: Column(
                  children: buildInputs() + buildSubmitButtons(),
                )),
          )
        ],
      )),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(
            labelText: '이메일 주소',
            labelStyle:
                TextStyle(fontFamily: 'Apple Medium', color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green[400])),
            errorStyle: TextStyle(fontFamily: 'Apple Medium')),
        validator: (value) => value.isEmpty ? '이메일 주소를 입력해 주세요' : null,
        onSaved: (value) => _email = value,
      ),
      SizedBox(height: 20.0),
      TextFormField(
        decoration: InputDecoration(
            labelText: '비밀번호',
            labelStyle:
                TextStyle(fontFamily: 'Apple Medium', color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green[400])),
            errorStyle: TextStyle(fontFamily: 'Apple Medium')),
        obscureText: true,
        validator: (value) => value.isEmpty ? '비밀번호를 입력해 주세요' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment(1.0, 0.0),
          padding: EdgeInsets.only(top: 15.0, left: 20.0),
          child: InkWell(
            child: Text(
              '비밀번호 찾기',
              style: TextStyle(
                  color: Colors.green[400],
                  fontFamily: 'Apple Semibold',
                  decoration: TextDecoration.underline),
            ),
          ),
        ),
        SizedBox(height: 40.0),
        Container(
          height: 40.0,
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: Colors.greenAccent,
            color: Colors.green[400],
            elevation: 7.0,
            child: GestureDetector(
              onTap: validateAndSubmit,
              child: Center(
                child: Text(
                  '로그인',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Apple Semibold'),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '처음이신가요?',
              style: TextStyle(fontFamily: 'Apple Semibold'),
            ),
            SizedBox(width: 5.0),
            InkWell(
              onTap: moveToRegister,
              child: Text(
                '회원가입',
                style: TextStyle(
                    color: Colors.green[400],
                    fontFamily: 'Apple Semibold',
                    decoration: TextDecoration.underline),
              ),
            )
          ],
        )
      ];
    } else {
      return [
        SizedBox(height: 5.0),
        SizedBox(height: 40.0),
        Container(
          height: 40.0,
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            shadowColor: Colors.greenAccent,
            color: Colors.green[400],
            elevation: 7.0,
            child: GestureDetector(
              onTap: validateAndSubmit,
              child: Center(
                child: Text(
                  '계정 생성하기',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Apple Semibold'),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '계정이 있으신가요?',
              style: TextStyle(fontFamily: 'Apple Semibold'),
            ),
            SizedBox(width: 5.0),
            InkWell(
              onTap: moveToLogin,
              child: Text(
                '로그인하기',
                style: TextStyle(
                    color: Colors.green[400],
                    fontFamily: 'Apple Semibold',
                    decoration: TextDecoration.underline),
              ),
            )
          ],
        )
      ];
    }
  }
}
