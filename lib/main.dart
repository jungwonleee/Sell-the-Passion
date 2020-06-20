import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';
import 'goal_provider.dart';
import 'auth_page.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseProvider>(
          create: (_) => FirebaseProvider()),
        ChangeNotifierProvider<Goal>(
          create: (_) => Goal()),
        ChangeNotifierProvider<SlaveGoal>(
          create: (_) => SlaveGoal()),
        ChangeNotifierProvider<User>(
          create: (_) => User())
      ],
      child: MaterialApp(
        title: "Sell the Passion",
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF66A091),
          accentColor: Color(0xFF776D61),
          splashColor: Colors.transparent,
          //highlightColor: Colors.transparent,
          fontFamily: 'Apple Semibold',
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