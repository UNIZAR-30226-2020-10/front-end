import 'package:flutter/material.dart';

import 'package:tuneit/classes/components/LateralMenu.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Podcast.dart';
import 'package:tuneit/pages/showList.dart';
import 'package:tuneit/pages/showPodcast.dart';
import 'package:tuneit/widgets/lists.dart';


class PlayLists extends StatefulWidget {
  @override
  _PlayListsState createState() => _PlayListsState();
}

class _PlayListsState extends State<PlayLists> {

  List<Playlist> listaPlaylists = List();
  List<Podcast> listaPodcast = List();
  var isLoading = false;


  void obtenerDatos() async{
    List<Playlist> listaPlay = await fetchPlaylists();
    List<Podcast> listaPodc = await fetchBestPodcasts();
    setState(() {
      listaPlaylists = listaPlay;
      listaPodcast = listaPodc;
    });

  }

  @override
  void initState() {
    super.initState();
    obtenerDatos();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.indigo[900],
        drawer: LateralMenu(),
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
            //contentList(true),
            //contentList(false),
            completeList (listaPlaylists, onTapPlaylists, []),
            completeList (listaPodcast, onTapPodcasts, []),
          ],
        ),
      ),
    );
  }

  void onTapPlaylists (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowList(indetificadorLista: listaPlaylists[index].id.toString(), list_title: listaPlaylists[index].name),
    ));
  }

  void onTapPodcasts (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowPodcast(podc: listaPodcast[index].id),
    ));
  }
}