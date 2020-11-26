import 'package:equatable/equatable.dart';
import 'package:flutter_music_app/model/Track_model.dart';
import 'package:meta/meta.dart';

abstract class TrackState extends Equatable {}

class TrackInitialState extends TrackState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class TrackLoadingState extends TrackState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class TrackLoadedState extends TrackState {

  List<TrackModel> tracks;
  TrackLoadedState({@required this.tracks});

  @override
  // TODO: implement props
  List<Object> get props => [tracks];
}

class ParticularTrackLoadedState extends TrackState {

  TrackModel track;
  String lyrics ;
  ParticularTrackLoadedState({@required this.track , this.lyrics});

  @override
  // TODO: implement props
  List<Object> get props => [track , lyrics];
}

class FavTrackLoadedState extends TrackState {

  List<SavedTrack> tracks;
  FavTrackLoadedState({@required this.tracks });

  @override
  // TODO: implement props
  List<Object> get props => [tracks];
}

class TrackErrorState extends TrackState {

  String message;
  TrackErrorState({@required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
