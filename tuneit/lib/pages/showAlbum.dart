import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Album.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/optionSongs.dart';


class ShowAlbum extends StatefulWidget {
  @override
  _State createState() => _State(name);

  String name;

  ShowAlbum(this.name);
}

class _State extends State<ShowAlbum> {

  String name;
  Album album;

  _State(this.name);

  void ObtenerDatos() async{
    Album aux = await searchAlbum(name);
    setState(() {
      album=aux;
    });

  }

  @override
  void initState(){
    ObtenerDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:AppBar(
        title:Text('ALBUM: ' + album.name),
        centerTitle: true,
        actions: <Widget>[

          PopupMenuButton<String>(
            onSelected: ActionPlaylist,
            itemBuilder: (BuildContext context){
              return optionCategory.map((String choice){
                return PopupMenuItem<String>(
                  value: (choice+"--"+album.name),
                  child: Text(choice),
                );

              }).toList();
            },
          ),
        ],
      ),

      body: Column(
          children: <Widget>[
            Expanded(
              child: ReorderableListView(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                onReorder: _onReorder,
                children: listaParaAudiosCategorias(context,album.songs,album.name,true,choiceAction),
              ),
            ),
          ]
      ),
      bottomNavigationBar: bottomExpandableAudio(),
    );


  }
  void _onReorder(int oldIndex, int newIndex) async{
    bool exito =await reposicionarCancion(album.name,oldIndex.toString(),newIndex.toString());
    if(exito){
      setState(
            () {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final Song item = album.songs.removeAt(oldIndex);
          album.songs.insert(newIndex, item);

        },
      );
    }
  }

  void ActionPlaylist(String contenido) async{
    List<String> opciones=contenido.split("--");
    String lista=opciones[1];

    if(opciones[0]==optionCategory[0]){
      print(opciones[0]);

      setState(() {
        album.songs = ordenarPorArtistaAudios(album.songs);
      });

    }
    else if(opciones[0]==optionCategory[1]){
      print(opciones[0]);

      setState(() {
        album.songs = ordenarPorTituloAudios(album.songs);
      });
    }
    else{
      print("Do nothing");
    }

  }
  void choiceAction(String choice) async{
    List<String> hola=choice.split("--");
    print(hola.toString());
    choice=hola[0];
    int id_song=int.parse(hola[1]);
    String id_lista=hola[2];
    int indice=int.parse(hola[3]);

    if(choice == optionMenuSongCategory[0]){
      List<Playlist>listas=await fetchPlaylists(Globals.email);
      mostrarListas(context,listas,id_song);
    }
    else if(choice ==optionMenuSongCategory[1]){

    }
    else if(choice == optionMenuSongCategory[2]){
      launchInBrowser(album.songs[indice].devolverTitulo(),album.songs[indice].devolverArtista());
    }
    else if(choice == optionMenuSongCategory[3]){
      agregada(context,Globals.id_fav,album.songs[indice].devolverTitulo());
      // Pedir la lista de favoritos actualizada
    }
    else{
      print ("Correct option was not found");

    }

  }

}