import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tuneit/classes/LateralMenu.dart';
import 'package:tuneit/classes/Playlist.dart';
import 'package:tuneit/classes/Podcast.dart';
import 'package:tuneit/classes/Podcast_Episode.dart';
import 'package:tuneit/pages/show_list.dart';
import 'package:tuneit/pages/show_podcast.dart';


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

  Widget list_box (BuildContext context, bool musNpodc, index) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if(musNpodc) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowList(indetificadorLista: list[index].id.toString(), list_title: list[index].name),
          ));
        }
        else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowPodcast(podc: list_p[index].id),
          ));
        }
      },
      child: template_list(
          musNpodc? (list[index].image != null? list[index].image : "https://i.blogs.es/2596e6/sonic/450_1000.jpg")
              : list_p[index].image,
          musNpodc? list[index].name : list_p[index].title
      ),
    );
  }

  Widget content_list(bool musNpodc) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: musNpodc? list.length : list_p.length,
      itemBuilder: (BuildContext context, int index) {
        return list_box(context, musNpodc, index);
      }
    );
  }
}