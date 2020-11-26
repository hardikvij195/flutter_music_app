import 'package:flutter/cupertino.dart';
import 'package:flutter_music_app/model/Api_result_model.dart';
import 'package:flutter_music_app/model/Track_model.dart';
import 'package:flutter_music_app/res/Res.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class TrackRepository {
  Future<List<TrackModel>> getTracks();
  Future<TrackModel> getParticularTrackInfo(String id);
  Future<String> getParticularTrackLyrics(String id);
  Future<List<SavedTrack>> getStringValuesSF(String id);

}

class TrackRepositoryImpl implements TrackRepository {


  @override
  Future<List<TrackModel>> getTracks() async {
    var response = await http.get(AppStrings.TracksUrl);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data['message']['body']);
      List<TrackModel> tracks = ApiResultModel.fromJson(data['message']['body']).tracks;
      print(tracks);
      return tracks;
    } else {
      throw Exception();
    }
  }

  @override
  Future<TrackModel> getParticularTrackInfo(String id) async {
    var response = await http.get(AppStrings.TrackInfoUrl1 + id + AppStrings.TrackInfoUrl2);
    print("Id ---- " + id);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data.toString());
      //print("Data --- 1 " + data);
      //print("Data --- 2 " + data['message']['body']);
      TrackModel track = ApiResultModelTrackInfo.fromJson(data['message']['body']).track;
      return track;
    } else {
      //print(response.body);
      throw Exception();
    }
  }

  @override
  Future<String> getParticularTrackLyrics(String id) async {
    var response = await http.get(AppStrings.TrackLyrics1 + id + AppStrings.TrackLyrics2);
    print("Id ---- " + id);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      //print("Data --- 1 " + data);
      //print("Data --- 2 " + data['message']['body']);
      String lyrics = ApiResultModelLyrics.fromJson(data['message']['body']).lyrics;
      return lyrics;
    } else {
      //print(response.body);
      throw Exception();
    }
  }

  @override
  Future<List<SavedTrack>> getStringValuesSF(String id) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(id) ?? '';
    if(stringValue != ''){

      List<SavedTrack> favlist = SavedTrack.decodeTasks(stringValue);
      print("Track -- " + favlist.toString());

      return favlist;
    }else{
      throw Exception();
    }

  }


}