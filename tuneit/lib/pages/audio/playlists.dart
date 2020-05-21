import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Podcast.dart';
import 'package:tuneit/classes/components/Searcher.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/audioPlayerClass.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/podcast/showPodcast.dart';
import 'package:tuneit/pages/songs/showList.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/playlistOption.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';


class PlayLists extends StatefulWidget {

  final bool musNpod;

  @override
  _PlayListsState createState() => _PlayListsState(musNpod);

  PlayLists(this.musNpod);
}

class _PlayListsState extends State<PlayLists> {

  bool musNpod;
  List<Playlist> listaPlaylists = List();
  List<Podcast> listaPodcast = List();
  var isLoading = false;

  _PlayListsState(this.musNpod);

  void obtenerDatos() async{
    if (musNpod) {
      List<Playlist> listaPlay = await fetchPlaylists(Globals.email);
      setState(() {
        listaPlaylists = listaPlay;
      });
    }
    else {
      List<Podcast> listaPodc = await fetchFavPodcasts();
      setState(() {
        listaPodcast = listaPodc;
      });
    }
  }

  Future<void> recuento() async{
    int dato= await contarNotificaciones();
    setState(() {

      Globals.mensajes_nuevo=dato;
    });
  }

  @override
  void initState() {
    super.initState();
    obtenerDatos();
    recuento();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: LateralMenu(),
        appBar: AppBar(
          title: Text(musNpod? 'MUSICA' : 'PODCASTS'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            new SizedBox(height: 10),
            musNpod?

            (new Row(
              children: <Widget>[
                Expanded(
                  flex:  4,
                  child: SizedBox(
                  ),
                ),
                Expanded(
                  flex: 70,
                  child: Searcher(musNpod),
                ),
                Expanded(
                  flex: 20,
                  child: musNpod?  crearListaRep(context) : new Container(width: 0, height: 0),
                ),
              ],
            ))

            :

            (new Row(
              children: <Widget>[
                Expanded(
                  flex:  4,
                  child: SizedBox(
                  ),
                ),
                Expanded(
                  flex: 70,
                  child: Searcher(musNpod),
                ),
                Expanded(
                  flex:  4,
                  child: SizedBox(
                  ),
                ),
              ],
            )),

            new SizedBox(height: 10),

            new Expanded(
              child: musNpod?
              completeList (listaPlaylists, onTapPlaylists, [])
                  :
              completeList (listaPodcast, onTapPodcasts, []),
            )
          ],
        ),
          bottomNavigationBar: bottomExpandableAudio(),
      ),
    );
  }

  void onTapPlaylists (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowList(indetificadorLista: listaPlaylists[index].id.toString(), list_title: listaPlaylists[index].name,esAmigo: false,),
    ));
  }

  void onTapPodcasts (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowPodcast(podcId: listaPodcast[index].id, podcName: listaPodcast[index].name),
    ));
  }
}