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
import 'package:flutter_music_app/ui/favs.dart';
import 'package:flutter_music_app/ui/track_details.dart';



class Home_Page extends StatefulWidget {
  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {


  Track_Bloc track_bloc;

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
    track_bloc = BlocProvider.of<Track_Bloc>(context);
    track_bloc.add(FetchTrackEvent());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Trending" , style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite , color: Colors.black,),
            onPressed: () {

              // Navigator.push(context, MaterialPageRoute(
              //   builder:(context) => Fav_Page()));

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider(create: (context) => FavTrack_Bloc(repository: TrackRepositoryImpl() ),
                    child: Fav_Page(),)
              ));

            },
          ),
          IconButton(
            icon: Icon(Icons.refresh , color: Colors.black,),
            onPressed: () {
              track_bloc.add(FetchTrackEvent());
            },
          ),
        ],
      ),


      body:
      _connectionStatus == ConnectivityResult.none.toString() ?
        Container(
        child: Center(
          child: Text("No Internet Connection"),
        ),) :
      Container(
        child: BlocListener<Track_Bloc, TrackState>(
          listener: (context, state) {
            if (state is TrackErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<Track_Bloc, TrackState>(
            builder: (context, state) {
              if (state is TrackInitialState) {
                return buildLoading();
              } else if (state is TrackLoadingState) {
                return buildLoading();
              } else if (state is TrackLoadedState) {
                return buildTrackList(state.tracks);
              } else if (state is TrackErrorState) {
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
  Future<void> _pullRefresh() async {
    track_bloc.add(FetchTrackEvent());
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  Widget buildTrackList(List<TrackModel> tracks) {
    //return Text("tracks");
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: ListView.separated(
        itemCount: tracks.length,
        itemBuilder: (ctx, pos) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){

              //BlocProvider<ParticularTrack_Bloc>(create: (context) => ParticularTrack_Bloc(repository: TrackRepositoryImpl()));

              // Navigator.push(context, MaterialPageRoute(
              //   builder: (context){
              //     return Track_Details(tracks[pos].id.toString());
              //   }
              // ));

              // Navigator.of(context).push(MaterialPageRoute<Track_Details>(
              //   builder: (_) => BlocProvider.value(value:BlocProvider.of<ParticularTrack_Bloc>(context),
              //   child: Track_Details(tracks[pos].id.toString()),)
              // ));


              Navigator.of(context).push(MaterialPageRoute<Track_Details>(
                builder: (_) => BlocProvider(create: (context) => ParticularTrack_Bloc(repository: TrackRepositoryImpl() , Trackid: tracks[pos].id.toString()),
                child: Track_Details(tracks[pos].id.toString()),)
              ));

            },
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
          ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey,
            thickness: 1.0,
          );
        },
      ),
    );
  }

}
