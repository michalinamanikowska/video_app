import 'package:bloc/bloc.dart';
import '../repositories/videos_repository.dart';
import 'videos_events.dart';
import 'videos_states.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  VideosRepository videosRepository;
  VideosBloc(this.videosRepository) : super(VideosAreLoading());
  List videos = [];

  @override
  Stream<VideosState> mapEventToState(VideosEvent event) async* {
    if (event is FetchVideos) {
      yield VideosAreLoading();
      try {
        videos = await videosRepository.getVideos();
        yield VideosAreLoaded(videos);
      } catch (_) {
        yield VideosAreNotLoaded();
      }
    } else if (event is SortVideos) {
      videos = videosRepository.sortVideos(videos, event.touchedVideo);
      yield VideosAreSorted(videos);
    }
  }
}
