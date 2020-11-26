import 'dart:convert';

class TrackModel {
  String id;
  String track_name;
  String artist_name;
  String album_name;
  String track_rating;
  String explicit;

  TrackModel({this.id, this.track_name , this.artist_name , this.album_name , this.track_rating , this.explicit});

  TrackModel.fromJson(Map<String, dynamic> json) {
    id = json['track']['track_id'].toString();
    track_name = json['track']['track_name'];
    artist_name = json['track']['artist_name'];
    album_name = json['track']['album_name'];
    track_rating = json['track']['track_rating'].toString();
    explicit = json['track']['explicit'] == 0 ? "False" : "True";


    print(" ---------------------------------- \n");
    print(id);
    print(track_name);
    print(artist_name);

  }
}



class SavedTrack{

  String id;
  String track_name;
  String artist_name;
  String album_name;
  String track_rating;
  String explicit;

  SavedTrack({this.id, this.track_name , this.artist_name , this.album_name , this.track_rating , this.explicit});

  factory SavedTrack.fromJson(Map<String, dynamic> jsonData) {
    return SavedTrack(
        id: jsonData['id'],
        track_name: jsonData['track_name'],
        artist_name: jsonData['artist_name'],
        album_name: jsonData['album_name'],
        track_rating: jsonData['track_rating'],
        explicit: jsonData['explicit'],
    );
  }

  static Map<String, dynamic> toMap(SavedTrack track) => {
    'id': track.id,
    'track_name': track.track_name,
    'artist_name': track.artist_name,
    'album_name': track.album_name,
    'track_rating': track.track_rating,
    'explicit': track.explicit,
  };

  static String encodeTasks(List<SavedTrack> track) => json.encode(
    track
        .map<Map<String, dynamic>>((track) => SavedTrack.toMap(track))
        .toList(),
  );

  static List<SavedTrack> decodeTasks(String track) =>
      (json.decode(track) as List<dynamic>)
          .map<SavedTrack>((item) => SavedTrack.fromJson(item))
          .toList();

}