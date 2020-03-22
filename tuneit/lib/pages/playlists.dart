import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tuneit/classes/LateralMenu.dart';
import 'package:tuneit/classes/Playlist.dart';


class PlayLists extends StatefulWidget {
  @override
  _PlayListsState createState() => _PlayListsState();
}

class _PlayListsState extends State<PlayLists> {

  Future<Playlist> futurePlaylist;

  @override
  void initState() {
    super.initState();
    futurePlaylist = fetchPlaylists();
  }

  //----------------------------------------------------//

  //Cargar datos

  Future<Playlist> fetchPlaylists() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/albums/1');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Playlist.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load playlists');
    }
  }

  //----------------------------------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        title: Text('Lista de reproduccion'),
        centerTitle: true,
      ),
      drawer: MenuLateral(),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          playlist_box(context, '/list', 'Favoritos', 'assets/1.jpg'),
          playlist_box(context, '/list', 'Mi lista', 'assets/2.jpeg'),
          playlist_box(context, '/list', 'Favoritos', 'assets/1.jpg'),
          playlist_box(context, '/list', 'Mi lista', 'assets/2.jpeg'),
        ],
      ),
    );
  }
}

Widget template_playlist (String image, String playlist_name) {
  return new Container(
    decoration: new BoxDecoration(
        color: Colors.indigo[700],
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(8.0),
          topRight: const Radius.circular(8.0),
          bottomLeft: const Radius.circular(8.0),
          bottomRight: const Radius.circular(8.0),
        )
    ),
    child: Center(
        child: Column(
            children: <Widget>[
              Flexible(
                  flex: 5,
                  child: new Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                        image: new AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ),
              Flexible(
                flex: 1,
                child: Center(child: Text(
                  playlist_name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                ),
              ),
            ]
        )
    ),
    margin: const EdgeInsets.all(8.0),
    padding: const EdgeInsets.all(1),
  );
}

Widget playlist_box (BuildContext context, String route, String playlist_name, String image) {
  return new GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      Navigator.pushNamed(context, route ,arguments: {
        'list_title': playlist_name
      });
    },
    child: template_playlist(image, playlist_name),
  );
}
/*
  Ejemplo crear el widget con la peticion http GET:

    body: Center(
      child: FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.title);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),

 */