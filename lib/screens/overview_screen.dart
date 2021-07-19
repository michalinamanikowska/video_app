import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/video.dart';
import '../widgets/video_item.dart';
import 'video_player_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List _videos = [];
  bool _isLoading = true;

  Future<void> updateCounters(String title, int counter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(title, counter);
  }

  Future<void> getCounters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _videos.forEach((element) {
      final counter = prefs.getInt(element.title) ?? 0;
      element.counter = counter;
      print(element.title + element.counter.toString());
    });
  }

  Future<void> getData() async {
    try {
      final url = Uri.parse('http://zryjto.linuxpl.info/zadanko-api/index.php');
      final response = await http.get(url);
      final data = json.decode(response.body);
      data.forEach((element) {
        final video = MyVideo(
            id: element['id'],
            title: element['title'],
            manifest: element['manifest']);
        _videos.add(video);
      });
      await getCounters();
      setState(() {
        _videos.sort((v1, v2) => v2.counter.compareTo(v1.counter));
        _isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('An error has occurred.\nCheck your internet connection.'),
          action: SnackBarAction(
            label: "Ok",
            onPressed: () => setState(() {
              _isLoading = false;
            }),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void tapReaction(MyVideo video) {
    final index = _videos.indexWhere((element) => element.id == video.id);
    _videos[index].counter += 1;
    final counter = _videos[index].counter;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => VideoPlayerScreen(video)));
    setState(() {
      _videos.sort((v1, v2) => v2.counter.compareTo(v1.counter));
    });
    updateCounters(video.title, counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).accentColor,
              ),
            )
          : ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: VideoItem(_videos[index]),
                  onTap: () {
                    final chosenVideo = _videos[index];
                    tapReaction(chosenVideo);
                  },
                );
              },
            ),
    );
  }
}
