import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:tuneit/classes/components/audio/Audio.dart';
import 'package:tuneit/classes/components/playlist/Playlist.dart';
import 'package:tuneit/classes/components/cancion/Song.dart';
import 'package:tuneit/classes/components/usuario/User.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/optionSongs.dart';



class ResultSongList extends StatefulWidget {
  List<Audio> songs= new List<Song>();
  String list_title;

  ResultSongList(this.songs,this.list_title);

  @override
  _ResultSongListState createState() => _ResultSongListState(songs,list_title);
}

class _ResultSongListState extends State<ResultSongList> {
  int indice;
  List<Audio> songs= new List<Song>();
  String list_title;

  _ResultSongListState(this.songs,this.list_title);





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
      agregada(context,Globals.id_fav,widget.songs[indice].devolverTitulo(),false);
      // Pedir la lista de favoritos actualizada
    }
    else{
      print ("Correct option was not found");

    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text( 'TuneIT'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(textoResultado,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 32
              ),
            ),
          ),
          Expanded(
            child:ListView(
            children: listaParaAudiosCategorias(context,widget.songs, "NoLista",true,choiceAction),
          ),
            ),
        ],
      ),
    );
  }
}

