import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sell_the_passion/goal_management_page.dart';
import 'package:sell_the_passion/my_page.dart';
import 'package:sell_the_passion/photo_uploader.dart';

import 'firebase_provider.dart';
import 'goal_provider.dart';
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
  int _selectedIndex = 0;
  TextStyle applesb = const TextStyle(fontFamily: 'Apple Semibold', color: Colors.white);
  static const TextStyle mainText = TextStyle(fontFamily: 'Apple Semibold', fontSize: 30);
  static const TextStyle optionText = TextStyle(fontFamily: 'Apple Medium');

  void _onItemTapped(int index) {
    if (index == 2) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    Goal goal = Provider.of<Goal>(context);

    List<Widget> _screens = <Widget>[
      GoalManagementPage(),
      Container(color: Colors.green),
      Container(color: Colors.blue),
      Container(color: Colors.cyan),
      MyPage()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome", style: applesb),
        backgroundColor: Theme.of(context).primaryColor,
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
      body: _screens[_selectedIndex],
      floatingActionButton: SizedBox(
        height: 70.0,
        width: 70.0,
        child: FloatingActionButton(
          onPressed: () async {
            if (goal!=null && goal.startDate!=null)
              PhotoUploader.uploadImageToStorage(ImageSource.camera, goal.startDate, fp);
          },
          child: Icon(Icons.camera, size: 60),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
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
              icon: Icon(Icons.add_a_photo, color: Colors.transparent),
              title: Text('인증하기', style: TextStyle(color: Colors.transparent)),
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
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}