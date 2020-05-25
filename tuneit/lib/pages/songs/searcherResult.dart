import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Artist.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/songs/showList.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/optionSongs.dart';

import '../artistProfile.dart';

class SearcherResult extends StatefulWidget {

  List<Audio> songs = new List<Song>();
  List<Playlist> playlists = new List<Playlist>();
  List<Artist> artists = new List<Artist>();

  SearcherResult(this.songs, this.playlists, this.artists);

  @override
  _SearcherResultState createState() => _SearcherResultState(songs, playlists, artists);
}

class _SearcherResultState extends State<SearcherResult> {

  List<Audio> songs= new List<Song>();
  List<Playlist> playlists = new List<Playlist>();
  List<Artist> artists = new List<Artist>();

  _SearcherResultState(this.songs, this.playlists, this.artists);

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
            artistsNotEmpty(),
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
              return listaParaAudiosCategorias(context, songs, "NoLista", true, choiceAction) [index];
            }
        ),
      ],
    );
  }

  Widget artistsNotEmpty () {
    return Column(
      children: <Widget>[
        SizedBox(height: 15,),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('   Artistas', style: Theme.of(context).textTheme.subtitle,),
        ),
        SizedBox(height: 10,),
        // Vertical: completeListNotScrollable(playlists, onTapPlaylist, []),
        artists.isEmpty?
        Align(
          alignment: Alignment.center,
          child: Text('No hay resultados', style: Theme.of(context).textTheme.subtitle,),
        )
            :
        Container(
          height: 200,
          child: completeListHorizontal(artists, onTapArtist, []),
        ),
      ],
    );
  }

  void onTapPlaylist (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ShowList(indetificadorLista: playlists[index].id.toString(), list_title: playlists[index].name),
    ));
  }

  void onTapArtist (int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ArtistProfile(name: artists[index].name),
    ));
  }

  void choiceAction(String choice) async{
    List<String> hola=choice.split("--");
    choice=hola[0];
    int id_song=int.parse(hola[1]);
    String id_lista=hola[2];
    int indice=int.parse(hola[3]);

    if(choice == optionMenuSongCategory[0]){
      List<Playlist>listas=await fetchPlaylists(Globals.email);
      mostrarListas(context,listas,id_song,false);
    }
    else if(choice ==optionMenuSongCategory[1]){
      List<User> amigos=await listarAmigos();
      mostrarAmigos(context,amigos,id_song);
    }
    else if(choice == optionMenuSongCategory[2]){
      launchInBrowser(widget.songs[indice].devolverTitulo(),widget.songs[indice].devolverArtista());
    }
    else if(choice == optionMenuSongCategory[3]){
      agregarCancion(Globals.idFavorite,id_song.toString());
      agregada(context,Globals.idFavorite,widget.songs[indice].devolverTitulo(),false);
      // Pedir la lista de favoritos actualizada
    }
    else{
      print ("Correct option was not found");

    }

  }
}
