import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/Track_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fav_Page extends StatefulWidget {
  @override
  _Fav_PageState createState() => _Fav_PageState();
}

class _Fav_PageState extends State<Fav_Page> {

  List<SavedTrack> favlist = List<SavedTrack>();
  //SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getStringValuesSF("tracks");
  }

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
        title: Text("Favourites", style: TextStyle(color: Colors.black),),

      ),

      body:  favlist.length !=0 ?  Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey,
                thickness: 1.0,
              );
            },
            itemCount: favlist.length,
            itemBuilder: (BuildContext ctxt, int pos){
              return Row(
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
                        Text(favlist[pos].track_name.toString() , style: TextStyle(fontSize: 14 , color: Colors.black),),
                        Text(favlist[pos].artist_name.toString() , style: TextStyle(fontSize: 13 , color: Colors.grey),),
                      ],
                    ),
                  ),

                  Spacer(),

                  Container(
                      height: 50,
                      width: 100,
                      child: Text(favlist[pos].album_name.toString() , style: TextStyle(fontSize: 14 , color: Colors.black), )),

                ],
              );
            }
        ),
      ): Center(child: Text("No Tracks Present"),),
    );
  }
}



