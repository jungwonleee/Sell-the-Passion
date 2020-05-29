import 'dart:math';
import 'package:flutter/material.dart';

Positioned validateCard(
    Image img,
    double bottom,
    double right,
    double left,
    double cardWidth,
    double rotation,
    double skew,
    BuildContext context,
    Function dismissImg,
    int flag,
    Function addImg,
    Function swipeRight,
    Function swipeLeft) {
  Size screenSize = MediaQuery.of(context).size;
  return new Positioned(
    bottom: 100.0 + bottom,
    right: flag == 0 ? right != 0.0 ? right : null : null,
    left: flag == 1 ? right != 0.0 ? right : null : null,
    child: new Dismissible(
      key: new Key(new Random().toString()),
      crossAxisEndOffset: -0.1,
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart)
          dismissImg(img);
        else
          addImg(img);
      },
      child: new Transform(
        alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
        transform: new Matrix4.skewX(skew),
        child: new RotationTransition(
          turns: new AlwaysStoppedAnimation(flag == 0 ? rotation / 360 : -rotation / 360),
          child: new Card(
            color: Colors.transparent,
            elevation: 4.0,
            child: new Container(
              alignment: Alignment.center,
              width: screenSize.width / 1.2 + cardWidth,
              height: screenSize.height / 1.7,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(8.0),
              ),
              child: new Column(
                children: <Widget>[
                  new Container(
                    width: screenSize.width / 1.2 + cardWidth,
                    height: screenSize.height / 2.2,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: new Radius.circular(8.0),
                        topRight: new Radius.circular(8.0)
                      ),
                    ),
                    child: img,
                  ),
                  new Container(
                      width: screenSize.width / 1.2 + cardWidth,
                      height:
                          screenSize.height / 1.7 - screenSize.height / 2.2,
                      alignment: Alignment.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}