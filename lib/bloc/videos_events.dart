import 'package:equatable/equatable.dart';

class VideosEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchVideos extends VideosEvent {}

class SortVideos extends VideosEvent {
  final touchedVideo;
  SortVideos(this.touchedVideo);

  @override
  List<Object?> get props => [touchedVideo];
}
