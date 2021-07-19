import 'package:flutter/material.dart';

class VideoItem extends StatelessWidget {
  final _video;
  VideoItem(this._video);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Colors.white, Theme.of(context).accentColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: ListTile(
            title: Text(
              _video.title,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.videocam,
                color: Theme.of(context).accentColor, size: 25),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.transparent),
        ),
      ),
    );
  }
}
