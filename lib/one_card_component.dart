import 'dart:math';
import 'package:flutter/material.dart';

Positioned cardDemo(
    int index,
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
      crossAxisEndOffset: -0.3,
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart)
          dismissImg(index);
        else
          addImg(index);
      },
      child: new Transform(
        alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
        transform: new Matrix4.skewX(skew),
        child: new RotationTransition(
          turns: new AlwaysStoppedAnimation(
              flag == 0 ? rotation / 360 : -rotation / 360),
          child: new Hero(
            tag: "img",
            child: new GestureDetector(
              onTap: () {
                return;
              },
              child: new Card(
                color: Colors.transparent,
                elevation: 4.0,
                child: new Container(
                  alignment: Alignment.center,
                  width: screenSize.width / 1.2 + cardWidth,
                  height: screenSize.height / 1.7,
                  decoration: new BoxDecoration(
                    color: new Color.fromRGBO(121, 114, 173, 1.0),
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
                              topRight: new Radius.circular(8.0)),
                        ),
                      ),
                      new Container(
                          width: screenSize.width / 1.2 + cardWidth,
                          height:
                              screenSize.height / 1.7 - screenSize.height / 2.2,
                          alignment: Alignment.center,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new FlatButton(
                                  padding: new EdgeInsets.all(0.0),
                                  onPressed: () {
                                    swipeLeft();
                                  },
                                  child: new Container(
                                    height: 60.0,
                                    width: 130.0,
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          new BorderRadius.circular(60.0),
                                    ),
                                    child: new Text(
                                      "DON'T",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  )),
                              new FlatButton(
                                  padding: new EdgeInsets.all(0.0),
                                  onPressed: () {
                                    swipeRight();
                                  },
                                  child: new Container(
                                    height: 60.0,
                                    width: 130.0,
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius:
                                          new BorderRadius.circular(60.0),
                                    ),
                                    child: new Text(
                                      "I'M IN",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ))
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}