import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tuneit/classes/LateralMenu.dart';
import 'package:tuneit/classes/Playlist.dart';
import 'package:tuneit/classes/Podcast.dart';
import 'package:tuneit/pages/show_list.dart';


class PlayLists extends StatefulWidget {
  @override
  _PlayListsState createState() => _PlayListsState();
}

class _PlayListsState extends State<PlayLists> {

  List<Playlist> list = List();
  List<Podcast> list_p = List();
  var isLoading = false;


  void obtener_datos() async{
    List<Playlist> lista = await fetchPlaylists();
    List<Podcast> lista_p = await fetchBestPodcasts();
    setState(() {
      list = lista;
      list_p = lista_p;
    });

  }

  @override
  void initState() {
    super.initState();
    obtener_datos();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.indigo[900],
        drawer: MenuLateral(),
        appBar: AppBar(
          title: Text('Lista de reproduccion'),
          centerTitle: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'MÚSICA',
              ),
              Tab(
                  text: 'PODCAST',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            content_list(true),
            content_list(false),
          ],
        ),
      ),
    );
  }

  Widget template_list (String image, String playlist_name) {
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
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(

                          image: new NetworkImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                ),
                Flexible(
                  flex: 1,
                  child: Center(
                    child: FittedBox(
                      child: Text(playlist_name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ),
                ),
              ]
          )
      ),
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(1),
    );
  }

  Widget list_box (BuildContext context, String route, String playlist_name, String image, String id_lista) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShowList(indetificadorLista: id_lista,list_title: playlist_name),

        ));
      },
      child: template_list(image, playlist_name),
    );
  }

  Widget content_list(bool musNpodc) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: musNpodc? list.length : list_p.length,
      itemBuilder: (BuildContext context, int index) {
        if(musNpodc) {
          if(list[index].image!=null){
            return list_box(context, '/list', list[index].name, list[index].image,list[index].id.toString());
          }
          else{
            return list_box(context, '/list', list[index].name, "https://i.blogs.es/2596e6/sonic/450_1000.jpg",list[index].id.toString());
          }
        }
        else {
          return list_box(context, '/list', list_p[index].title, list_p[index].image, list_p[index].id);
        }
      }
    );
  }
}