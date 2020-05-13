import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Audio.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/optionSongs.dart';

class ShowCategory extends StatefulWidget {

  String name;

  ShowCategory({this.name});

  @override
  _ShowCategoryState createState() => _ShowCategoryState(name);
}

class _ShowCategoryState extends State<ShowCategory> {

  String name;
  List<Song> songs = List();

  _ShowCategoryState(this.name);

  void ObtenerDatos() async{
    List<Song> canciones = await songsByCategory([name]);
    setState(() {
      songs = canciones;
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
        title:Text(name),
        centerTitle: true,
        actions: <Widget>[

          PopupMenuButton<String>(
            onSelected: ActionPlaylist,
            itemBuilder: (BuildContext context){
              return optionCategory.map((String choice){
                return PopupMenuItem<String>(
                  value: (choice+"--"+name),
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
                children: listaParaAudiosCategorias(context, songs, name, false, choiceAction),
              ),
            ),
          ]
      ),
      bottomNavigationBar: bottomExpandableAudio(),
    );


  }
  void _onReorder(int oldIndex, int newIndex) async{
    bool exito =await reposicionarCancion(name,oldIndex.toString(),newIndex.toString());
    if(exito){
      setState(
            () {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final Song item = songs.removeAt(oldIndex);
          songs.insert(newIndex, item);

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
        songs = ordenarPorArtistaAudios(songs);
      });

    }
    else if(opciones[0]==optionCategory[1]){
      print(opciones[0]);

      setState(() {
        songs = ordenarPorTituloAudios(songs);
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
      launchInBrowser(songs[indice].devolverTitulo(),songs[indice].devolverArtista());
    }
    else if(choice == optionMenuSongCategory[3]){
      agregada(context,Globals.id_fav,songs[indice].devolverTitulo());
      // Pedir la lista de favoritos actualizada
    }
    else{
      print ("Correct option was not found");

    }

  }

}