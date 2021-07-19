import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final _video;
  VideoPlayerScreen(this._video);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool barVisibility = true;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget._video.manifest);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(() {
      if (_controller.value.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('This video could not be loaded.'),
          ),
        );
      }
    });
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget bar() {
    return Container(
      width: 150,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black.withOpacity(0.6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.fast_rewind, color: Colors.white),
            onPressed: () {
              setState(() {
                _controller
                    .seekTo(_controller.value.position - Duration(seconds: 10));
              });
            },
          ),
          IconButton(
            icon: _controller.value.isPlaying
                ? Icon(Icons.pause, color: Colors.white)
                : Icon(Icons.play_arrow, color: Colors.white),
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.fast_forward, color: Colors.white),
            onPressed: () {
              setState(() {
                _controller
                    .seekTo(_controller.value.position + Duration(seconds: 10));
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget._video.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      GestureDetector(
                        child: ClipRRect(
                          child: VideoPlayer(_controller),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        onTap: () {
                          setState(() => barVisibility = !barVisibility);
                        },
                      ),
                      Visibility(
                        child: bar(),
                        visible: barVisibility,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).accentColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
