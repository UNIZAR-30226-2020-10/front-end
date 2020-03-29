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

  List<Playlist> list = List();
  var isLoading = false;


  void obtener_datos() async{
    list = await fetchPlaylists();

  }

  @override
  void initState() {
    super.initState();
    obtener_datos();

    /*.then((list) {
      return list;
    }) as List<Playlist>;*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        title: Text('Lista de reproduccion'),
        centerTitle: true,
      ),
      drawer: MenuLateral(),
      /*body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          playlist_box(context, '/list', 'Favoritos', 'assets/1.jpg'),
          playlist_box(context, '/list', 'Mi lista', 'assets/2.jpeg'),
          playlist_box(context, '/list', 'Favoritos', 'assets/1.jpg'),
          playlist_box(context, '/list', 'Mi lista', 'assets/2.jpeg'),
        ],
      ),*/
      body: GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return playlist_box(context, '/list', list[index].name, list[index].image,list[index].id);
        },
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

Widget playlist_box (BuildContext context, String route, String playlist_name, String image, String id_lista) {
  return new GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      Navigator.pushNamed(context, route ,arguments: {
        'list_title': playlist_name,
        'indetificadorLista': id_lista
      });
    },
    child: template_playlist(image, playlist_name),
  );
}