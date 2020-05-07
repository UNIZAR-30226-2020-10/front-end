import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/songs/showList.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/optionSongs.dart';

class SearcherResult extends StatefulWidget {

  List<Audio> songs = new List<Song>();
  List<Playlist> playlists = new List<Playlist>();

  SearcherResult(this.songs, this.playlists);

  @override
  _SearcherResultState createState() => _SearcherResultState(songs, playlists);
}

class _SearcherResultState extends State<SearcherResult> {

  List<Audio> songs= new List<Song>();
  List<Playlist> playlists = new List<Playlist>();

  _SearcherResultState(this.songs, this.playlists);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text(textoResultado),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            playlistsNotEmpty(),
            songsNotEmpty(),
          ],
        ),
      ),
    );
  }

  Widget playlistsNotEmpty () {
    return Column(
      children: <Widget>[
        SizedBox(height: 15,),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('   Listas de reproducción', style: Theme.of(context).textTheme.subtitle,),
        ),
        SizedBox(height: 10,),
        // Vertical: completeListNotScrollable(playlists, onTapPlaylist, []),
        playlists.isEmpty?
        Align(
          alignment: Alignment.center,
          child: Text('No hay resultados', style: Theme.of(context).textTheme.subtitle,),
        )
        :
        Container(
          height: 200,
          child: completeListHorizontal(playlists, onTapPlaylist, []),
        ),
      ],
    );
  }

  Widget songsNotEmpty () {
    return Column(
      children: <Widget>[
        SizedBox(height: 15,),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('   Canciones', style: Theme.of(context).textTheme.subtitle,),
        ),
        SizedBox(height: 10,),
        songs.isEmpty?
        Align(
          alignment: Alignment.center,
          child: Text('No hay resultados', style: Theme.of(context).textTheme.subtitle,),
        )
        :
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: songs.length,
            itemBuilder: (BuildContext context, int index) {
              return listaParaAudios(context, songs, "NoLista", true, choiceAction) [index];
            }
        ),
      ],
    );
  }

  void onTapPlaylist (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowList(indetificadorLista: playlists[index].id.toString(), list_title: playlists[index].name),
    ));
  }

  void choiceAction(String choice) async{
    List<String> hola=choice.split("--");
    choice=hola[0];
    int id_song=int.parse(hola[1]);
    int indice=int.parse(hola[3]);

    if(choice == optionMenuSong[0]){
      List<Playlist>listas=await fetchPlaylists(Globals.email);
      mostrarListas(context,listas,id_song);
    }
    else if(choice ==optionMenuSong[1]){

    }
    else if(choice ==optionMenuSong[2]){

    }
    else if(choice == optionMenuSong[3]){
      launchInBrowser(widget.songs[indice].devolverTitulo(),widget.songs[indice].devolverArtista());
    }
    else if(choice == optionMenuSong[4]){
      agregada(context,Globals.id_fav,widget.songs[indice].devolverTitulo());
    }
    else{
      print ("Correct option was not found");

    }

  }
}
