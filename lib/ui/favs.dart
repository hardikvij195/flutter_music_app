import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_app/bloc/Track_bloc.dart';
import 'package:flutter_music_app/bloc/Track_event.dart';
import 'package:flutter_music_app/bloc/Track_state.dart';
import 'package:flutter_music_app/model/Track_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fav_Page extends StatefulWidget {
  @override
  _Fav_PageState createState() => _Fav_PageState();
}

class _Fav_PageState extends State<Fav_Page> {


  FavTrack_Bloc fav_track_bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fav_track_bloc = BlocProvider.of<FavTrack_Bloc>(context);
    fav_track_bloc.add(FetchTrackEvent());

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
        title: Text("Favourites", style: TextStyle(color: Colors.black),),

      ),
      body: Container(
        child: BlocListener<FavTrack_Bloc, TrackState>(
          listener: (context, state) {
            if (state is TrackErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<FavTrack_Bloc, TrackState>(
            builder: (context, state) {
              if (state is TrackInitialState) {
                return buildLoading();
              } else if (state is TrackLoadingState) {
                return buildLoading();
              } else if (state is FavTrackLoadedState) {
                return buildTrackList(state.tracks);
              } else if (state is TrackErrorState) {
                return buildErrorUi(state.message);
              }
              return buildLoading() ;
            },
          ),
        ),
      ),



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

  Widget buildTrackList(List<SavedTrack> tracks) {
    //return Text("tracks");
    return ListView.separated(
      itemCount: tracks.length,
      itemBuilder: (ctx, pos) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.music_note),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(tracks[pos].track_name.toString() , style: TextStyle(fontSize: 14 , color: Colors.black),),
                    Text(tracks[pos].artist_name.toString() , style: TextStyle(fontSize: 13 , color: Colors.grey),),
                  ],
                ),
              ),

              Spacer(),

              Container(
                  height: 50,
                  width: 100,
                  child: Text(tracks[pos].album_name.toString() , style: TextStyle(fontSize: 14 , color: Colors.black), )),

            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey,
          thickness: 1.0,
        );
      },
    );
  }




}



