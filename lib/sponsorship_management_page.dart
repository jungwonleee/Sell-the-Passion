import 'package:flutter/material.dart';

class SponsorshipManagementPage extends StatefulWidget {
  @override
  _SponsorshipManagementPageState createState() => _SponsorshipManagementPageState();
}

class _SponsorshipManagementPageState extends State<SponsorshipManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('후원할 목표가 아직 없습니다.', style: TextStyle(fontSize: 20)),
          Text('후원 매칭을 시작해보세요!', style: TextStyle(fontSize: 20))
        ],
      ),
    );
  }
}