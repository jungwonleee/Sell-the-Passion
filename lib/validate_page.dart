import 'dart:async';
import 'package:provider/provider.dart';
import 'package:sell_the_passion/goal_provider.dart';

import 'one_card_component.dart';
import 'dummy_card_component.dart';

//import 'package:animation_exp/PageReveal/page_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class ValidatePage extends StatefulWidget {
  final List<Image> images;
  ValidatePage(this.images);

  @override
  ValidatePageState createState() => new ValidatePageState();
}

class ValidatePageState extends State<ValidatePage> with TickerProviderStateMixin {
  List<Image> images;
  AnimationController _buttonController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;
  int flag = 0;

  List selectedData = [];
  void initState() {
    images = widget.images;
    print(images);
    super.initState();

    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    rotate = new Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {
      setState(() {
        if (rotate.isCompleted) {
          var i = images.removeLast();
          images.insert(0, i);
          _buttonController.reset();
        }
      });
    });

    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = new Tween<double>(
      begin: 15.0,
      end: 100.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = new Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  dismissImg(Image img) {
    setState(() {
      images.removeLast();
    });
  }

  addImg(Image img) {
    setState(() {
      images.removeLast();
      selectedData.add(img);
    });
  }

  swipeRight() {
    if (flag == 0)
      setState(() {
        flag = 1;
      });
    _swipeAnimation();
  }

  swipeLeft() {
    if (flag == 1)
      setState(() {
        flag = 0;
      });
    _swipeAnimation();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SlaveGoal goal = Provider.of<SlaveGoal>(context);
    DateTime now = new DateTime.now();
    DateTime startDate = goal.startDate;
    int week = (now.difference(startDate).inDays).toInt()~/7;

    double initialBottom = 15.0;
    var dataLength = images.length;
    double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    double backCardWidth = -10.0;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text('$week주차 주간평가'),
      ),
      body: new Container(
        alignment: Alignment.center,
        child: dataLength > 0
          ? new Stack(
                alignment: AlignmentDirectional.center,
                children: images.asMap().entries.map((entry) {
                  int index = entry.key;
                  Image item = entry.value;
                  if (true) {
                    return validateCard(
                      item,
                      bottom.value,
                      right.value,
                      0.0,
                      backCardWidth + 10,
                      rotate.value,
                      rotate.value < -10 ? 0.1 : 0.0,
                      context,
                      dismissImg,
                      flag,
                      addImg,
                      swipeRight,
                      swipeLeft
                    );
                  } else {
                    backCardPosition = backCardPosition - 10;
                    backCardWidth = backCardWidth + 10;
                    return dummyCard(backCardPosition, 0.0, 0.0, backCardWidth, 0.0, 0.0, context);
                  }
                }
              ).toList())
          : new Text("평가 완료!", style: new TextStyle(color: Colors.black, fontSize: 30.0)),
      )
    );
  }
}