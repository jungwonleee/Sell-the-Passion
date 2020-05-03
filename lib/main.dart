import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';
import 'auth_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseProvider>(
            create: (_) => FirebaseProvider())
      ],
      child: MaterialApp(
        title: "Sell_The_Passion",
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF66A091),
          accentColor: Color(0xFF776D61),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthPage();
  }
}