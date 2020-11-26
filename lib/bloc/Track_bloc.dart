import 'package:bloc/bloc.dart';
import 'package:flutter_music_app/bloc/Track_event.dart';
import 'package:flutter_music_app/bloc/Track_state.dart';
import 'package:flutter_music_app/model/Track_model.dart';
import 'package:flutter_music_app/repo/Track_repo.dart';
import 'package:meta/meta.dart';

class Track_Bloc extends Bloc<TrackEvent, TrackState> {

  TrackRepository repository;
  Track_Bloc({@required this.repository}) : super(null);

  @override
  // TODO: implement initialState
  TrackState get initialState => TrackInitialState();

  @override
  Stream<TrackState> mapEventToState(TrackEvent event) async* {
    if (event is FetchTrackEvent) {
      yield TrackLoadingState();
      try {
        List<TrackModel> tracks = await repository.getTracks();
        yield TrackLoadedState(tracks: tracks);
      } catch (e) {
        yield TrackErrorState(message: e.toString());
      }
    }
  }

}


class ParticularTrack_Bloc extends Bloc<TrackEvent, TrackState> {

  TrackRepository repository;
  String Trackid ;
  ParticularTrack_Bloc({@required this.repository , @required this.Trackid}) : super(null);

  @override
  // TODO: implement initialState
  TrackState get initialState => TrackInitialState();

  @override
  Stream<TrackState> mapEventToState(TrackEvent event) async* {
    if (event is FetchTrackEvent) {
      yield TrackLoadingState();
      try {
        TrackModel track = await repository.getParticularTrackInfo(this.Trackid);
        String Lyrics = await repository.getParticularTrackLyrics(this.Trackid);
        print(Lyrics);
        //print("Track Id ---" + this.Trackid);
        yield ParticularTrackLoadedState(track: track , lyrics: Lyrics);
      } catch (e) {
        yield TrackErrorState(message: e.toString());
      }
    }
  }

}


class FavTrack_Bloc extends Bloc<TrackEvent, TrackState> {

  TrackRepository repository;
  FavTrack_Bloc({@required this.repository }) : super(null);

  @override
  // TODO: implement initialState
  TrackState get initialState => TrackInitialState();

  @override
  Stream<TrackState> mapEventToState(TrackEvent event) async* {
    if (event is FetchTrackEvent) {
      yield TrackLoadingState();
      try {
        List<SavedTrack> tracks = await repository.getStringValuesSF("tracks");
        yield FavTrackLoadedState(tracks: tracks);
      } catch (e) {
        yield TrackErrorState(message: e.toString());
      }
    }
  }

}