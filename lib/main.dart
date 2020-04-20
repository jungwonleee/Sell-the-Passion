import 'package:flutter/material.dart';
import 'login_page.dart';
import 'auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new LoginPage(auth: new Auth()));
  }
}
