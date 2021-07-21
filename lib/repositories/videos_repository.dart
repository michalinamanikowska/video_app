import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/video.dart';

class VideosRepository {
  Future<List<dynamic>> getCounters(List videos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    videos.forEach((element) {
      final counter = prefs.getInt(element.title) ?? 0;
      element.counter = counter;
    });
    return videos;
  }

  Future<void> updateCounters(String title, int counter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(title, counter);
  }

  Future<List<dynamic>> getVideos() async {
    final url = Uri.parse('http://zryjto.linuxpl.info/zadanko-api/index.php');
    final response = await http.get(url);
    if (response.statusCode != 200) throw Exception();
    var data = json.decode(response.body);
    List _videos = [];
    data.forEach((element) {
      final video = MyVideo(
          id: element['id'],
          title: element['title'],
          manifest: element['manifest']);
      _videos.add(video);
    });
    _videos = await getCounters(_videos);
    _videos.sort((v1, v2) => v2.counter.compareTo(v1.counter));
    return _videos;
  }

  List<dynamic> sortVideos(List videos, MyVideo video) {
    final index = videos.indexWhere((element) => element.id == video.id);
    videos[index].counter += 1;
    final counter = videos[index].counter;
    updateCounters(video.title, counter);
    videos.sort((v1, v2) => v2.counter.compareTo(v1.counter));
    return videos;
  }
}
