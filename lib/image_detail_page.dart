import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailPage extends StatefulWidget {
  final String image;
  final DateTime imageDate;
  ImageDetailPage(this.image, this.imageDate);

  @override
  _ImageDetailPageState createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  String image;
  List<String> weekDay = ['일', '월', '화', '수', '목', '금', '토'];
  DateTime imageDate;

  @override
  void initState() {
    image = widget.image;
    imageDate = widget.imageDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('${imageDate.year}년 ${imageDate.month}월 ${imageDate.day}일 ${weekDay[imageDate.weekday%7]}요일'), backgroundColor: Colors.transparent),
      body: Center(
        child:PhotoView(
          imageProvider: NetworkImage(image),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 5,
          initialScale: PhotoViewComputedScale.contained,
          heroAttributes: PhotoViewHeroAttributes(
            tag: image,
            transitionOnUserGestures: true
          ),
        ),
      ),
    );
  }
}