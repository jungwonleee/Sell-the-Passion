import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sell_the_passion/goal_management_page.dart';
import 'sponsorship_management_page.dart';
import 'notification_page.dart';
import 'package:sell_the_passion/my_page.dart';
import 'package:sell_the_passion/photo_uploader.dart';
import 'firebase_provider.dart';
import 'goal_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'point_top_up_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

SignedInPageState pageState;

class SignedInPage extends StatefulWidget {
  @override
  SignedInPageState createState() {
    pageState = SignedInPageState();
    return pageState;
  }
}

const Color mint = Color(0xFF66A091);

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

  List<String> appBarTitle = ['목표관리','후원관리','','알림','마이페이지'];

  List<Widget> _screens = <Widget>[
    GoalManagementPage(),
    SponsorshipManagementPage(),
    Container(color: Colors.blue),
    NotificationPage(),
    MyPage()
  ];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context, listen: false);
    super.initState();
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${fp.getUser().uid}');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        /*final notification = message['data'];
        setState(() {
          dbRef.child("notification").push().set({
            'type': notification['type'],
            'title': notification['title'],
            'body': notification['body']
          });
        });*/
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        /*final notification = message['data'];
        setState(() {
          dbRef.child("notification").push().set({
            'type': notification['type'],
            'title': notification['title'],
            'body': notification['body']
          });
        });*/
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of<FirebaseProvider>(context);
    Goal goal = Provider.of<Goal>(context);
    DateTime now = new DateTime.now();
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child('users/${fp.getUser().uid}');

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle[_selectedIndex], style: applesb),
        backgroundColor: _selectedIndex == 1 ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      endDrawer: _selectedIndex == 4 ? Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: mint),
              child: SafeArea(
                child: ListTile(
                  title: Text('메뉴', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ),
            ListTile(
              title: Text('포인트 충전', style: TextStyle(fontSize: 20)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return PointTopUpPage();
                }));
              },
            ),
            ListTile(
              title: Text('로그아웃', style: TextStyle(fontSize: 20)),
              onTap: fp.signOut,
            ),
            ListTile(
              title: Text('회원탈퇴', style: TextStyle(fontSize: 20)),
              onTap: (){
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text('정말로 탈퇴하시겠습니까?'),
                    content: Text('탈퇴하는 경우 기존의 사용자 정보는 모두 삭제됩니다.'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('취소', style: TextStyle(color: mint),),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('확인', style: TextStyle(color: mint),),
                        onPressed: () {
                          fp.signOut();
                          dbRef.remove();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
              },
            ),
          ],
        ),
      ) : null,
      body: _screens[_selectedIndex],
      floatingActionButton: SizedBox(
        height: 70.0,
        width: 70.0,
        child: FloatingActionButton(
          onPressed: () async {
            if (goal.title == null || goal.startDate == null) {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text('오류'),
                  content: Text('인증 기능은 매칭 이후에 사용하실 수 있습니다.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('확인', style: TextStyle(color: mint),),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
            }
            else if (!goal.authDay[now.weekday%7]) {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text('오류'),
                  content: Text('오늘은 인증 날짜가 아닙니다.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('확인', style: TextStyle(color: mint),),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
            }
            else PhotoUploader.uploadImageToStorage(ImageSource.camera, goal.startDate, fp);
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
              icon: Icon(Icons.notifications),
              title: Text('알림', style: optionText),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
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