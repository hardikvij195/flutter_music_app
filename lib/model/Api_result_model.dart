import 'package:flutter_music_app/model/Track_model.dart';

class ApiResultModel {
  List<TrackModel> tracks;
  ApiResultModel({this.tracks});
  ApiResultModel.fromJson(Map<String, dynamic> json) {
    if (json['track_list'] != null) {
      tracks = new List<TrackModel>();
      json['track_list'].forEach((v) {
        tracks.add(new TrackModel.fromJson(v));
      });
    }
  }
}


class ApiResultModelTrackInfo {
  TrackModel track;
  ApiResultModelTrackInfo({this.track});
  ApiResultModelTrackInfo.fromJson(Map<String, dynamic> json) {
    if (json['track'] != null) {
      track = new TrackModel.fromJson(json);
      //print("Track --------------- " + json['track']);
    }
  }

}

class ApiResultModelLyrics {
  String lyrics;
  ApiResultModelLyrics({this.lyrics});
  ApiResultModelLyrics.fromJson(Map<String, dynamic> json) {
    if (json['lyrics'] != null) {
      lyrics = json['lyrics']['lyrics_body'];
      //print("Track --------------- " + json['track']);
    }
  }

}

