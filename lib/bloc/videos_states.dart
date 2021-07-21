import 'package:equatable/equatable.dart';

class VideosState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VideosAreLoading extends VideosState {}

class VideosAreLoaded extends VideosState {
  final _videos;
  VideosAreLoaded(this._videos);

  List<dynamic> get getData => _videos;

  @override
  List<Object?> get props => [_videos];
}

class VideosAreNotLoaded extends VideosState {}

class VideosAreSorted extends VideosState {
  final _videos;
  VideosAreSorted(this._videos);

  List<dynamic> get sortedData => _videos;

  @override
  List<Object?> get props => [_videos];
}
