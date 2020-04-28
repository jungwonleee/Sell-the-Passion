import 'package:flutter/material.dart';
//import 'package:sell_the_passion/main.dart';
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
  
  int _selectedIndex = 0;
  TextStyle applesb =const TextStyle(fontFamily: 'Apple Semibold');
  static const TextStyle mainText = TextStyle(fontFamily: 'Apple Semibold', fontSize: 30);
  static const TextStyle optionText = TextStyle(fontFamily: 'Apple Medium');

  static const List<Widget> _widgetOptions = <Widget>[
    Text('목표관리', style: mainText),
    Text('후원관리', style: mainText),
    Text('인증하기', style: mainText),
    Text('뉴스피드', style: mainText),
    Text('마이페이지', style: mainText),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome", style: applesb),
        backgroundColor: Color(0xFF66A091),
        actions: <Widget>[
          FlatButton(
            child: Text('로그아웃', style: TextStyle(
              fontFamily: 'Apple Semibold',
              color: Colors.white)
            ),
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
            Text(fp.getUser().displayName, style: mainText),
            _widgetOptions.elementAt(_selectedIndex),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('목표관리', style: optionText),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text('후원관리', style: optionText),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            title: Text('인증하기', style: optionText),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            title: Text('뉴스피드', style: optionText),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text('마이페이지', style: optionText),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color(0xFF66A091),
        onTap: _onItemTapped,
      ),
    );
  }
}