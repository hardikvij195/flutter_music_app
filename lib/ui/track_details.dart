import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_app/bloc/Track_bloc.dart';
import 'package:flutter_music_app/bloc/Track_event.dart';
import 'package:flutter_music_app/bloc/Track_state.dart';
import 'package:flutter_music_app/model/Track_model.dart';
import 'package:flutter_music_app/repo/Track_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Track_Details extends StatefulWidget {
  String Track_Id ;
  Track_Details(this.Track_Id );

  @override
  _Track_DetailsState createState() => _Track_DetailsState();
}

class _Track_DetailsState extends State<Track_Details> {

  ParticularTrack_Bloc particularTrack_Bloc;

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }


  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    particularTrack_Bloc = BlocProvider.of<ParticularTrack_Bloc>(context);
    particularTrack_Bloc.add(FetchTrackEvent());
    getStringValuesSF("tracks");

  }

  List<SavedTrack> favlist = List<SavedTrack>();

  SavedTrack currentTrack ;

  Future<List<SavedTrack>> getStringValuesSF(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString(id) ?? '';

    if(stringValue != ''){
      setState(() {
        favlist = SavedTrack.decodeTasks(stringValue);
        print("Track -- " + favlist.toString());
      });

    }
    return favlist;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text("Track Details", style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_border , color: Colors.black,),
            onPressed: () async {

              SharedPreferences prefs = await SharedPreferences.getInstance();
              //favlist.add(SavedTrack(id: widget.Track_Id , track_name: "" , artist_name: "" , album_name: "" , explicit:  "" , track_rating: "" ));

              bool exist = false ;
              for( int i= 0 ; i< favlist.length ; i++){
                String id = currentTrack.id;
                if(favlist[i].id == id){
                  exist = true;
                  break;
                }
              }

              if(!exist){
                favlist.add(currentTrack);
                print("Just Added");
                final String encodedData = SavedTrack.encodeTasks(favlist);
                prefs.setString("tracks", encodedData);
              }else{
                print("Exist");
              }



            },
          ),
          // IconButton(
          //   icon: Icon(Icons.refresh , color: Colors.black,),
          //   onPressed: () {
          //     track_bloc.add(FetchTrackEvent());
          //   },
          // ),
        ],
      ),
        body:
        _connectionStatus == ConnectivityResult.none.toString() ?
    Container(
      child: Center(
        child: Text("No Internet Connection"),
      ),) :

        Container(
          child: BlocListener<ParticularTrack_Bloc, TrackState>(
            listener: (context, state) {
              if (state is TrackErrorState) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            child: BlocBuilder<ParticularTrack_Bloc, TrackState>(
              builder: (context, state) {
                if (state is TrackInitialState) {
                  return buildLoading();
                } else if (state is TrackLoadingState) {
                  return buildLoading();
                } else if (state is ParticularTrackLoadedState) {

                  currentTrack = SavedTrack(id: state.track.id , track_name: state.track.track_name , artist_name: state.track.artist_name , album_name: state.track.album_name , track_rating: state.track.track_rating , explicit: state.track.explicit);
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: ListView(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30,),
                        Text("Name", style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 16),),
                        Text(state.track.track_name , style: TextStyle(color: Colors.black , fontWeight: FontWeight.normal , fontSize: 16),),
                        SizedBox(height: 30,),

                        Text("Artist", style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 16),),
                        Text(state.track.album_name , style: TextStyle(color: Colors.black , fontWeight: FontWeight.normal , fontSize: 16),),

                        SizedBox(height: 30,),

                        Text("Album Name", style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 16),),

                        Text(state.track.artist_name , style: TextStyle(color: Colors.black , fontWeight: FontWeight.normal , fontSize: 16),),
                        SizedBox(height: 30,),

                        Text("Explicit", style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 16),),
                        Text(state.track.explicit , style: TextStyle(color: Colors.black , fontWeight: FontWeight.normal , fontSize: 16),),

                        SizedBox(height: 30,),

                        Text("Rating", style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 16),),
                        Text(state.track.track_rating , style: TextStyle(color: Colors.black , fontWeight: FontWeight.normal , fontSize: 16),),
                        SizedBox(height: 30,),
                        Text("Lyrics", style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold , fontSize: 16),),
                        Text(state.lyrics , style: TextStyle(color: Colors.black , fontWeight: FontWeight.normal , fontSize: 16),),
                        SizedBox(height: 30,),

                      ],
                    ),
                  );
                } else if (state is TrackLoadedState) {
                  return Text("Track Loaded");
                }else if (state is TrackErrorState) {
                  return buildErrorUi(state.message);
                }
                return buildLoading() ;
              },
            ),
          ),
        )


    );
  }



  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
      ),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }




}
