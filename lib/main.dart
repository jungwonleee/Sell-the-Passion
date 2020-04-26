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
        debugShowCheckedModeBanner: false,
        title: "Flutter Firebase",
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