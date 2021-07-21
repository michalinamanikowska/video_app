import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'video_player_screen.dart';
import '../models/video.dart';
import '../widgets/video_item.dart';
import '../bloc/videos_bloc.dart';
import '../bloc/videos_events.dart';
import '../bloc/videos_states.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  void startConnection() {
    final videosBloc = BlocProvider.of<VideosBloc>(context);
    videosBloc.add(FetchVideos());
  }

  @override
  void initState() {
    startConnection();
    super.initState();
  }

  void tapReaction(MyVideo video) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => VideoPlayerScreen(video)))
        .then((_) {
      setState(() {
        final videosBloc = BlocProvider.of<VideosBloc>(context);
        videosBloc.add(SortVideos(video));
      });
    });
  }

  Widget listOfVideos(List videos) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: VideoItem(videos[index]),
          onTap: () {
            final chosenVideo = videos[index];
            tapReaction(chosenVideo);
          },
        );
      },
    );
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
      body: BlocConsumer<VideosBloc, VideosState>(
        listener: (context, state) {
          if (state is VideosAreNotLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'An error has occurred.\nCheck your internet connection.'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is VideosAreLoading)
            return Center(child: CircularProgressIndicator());
          else if (state is VideosAreLoaded) {
            return listOfVideos(state.getData);
          } else if (state is VideosAreSorted) {
            return listOfVideos(state.sortedData);
          } else
            return Center(
              child: ElevatedButton(
                  child: Text(
                    'RESTART',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: startConnection),
            );
        },
      ),
    );
  }
}
