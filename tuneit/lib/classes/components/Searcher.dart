

import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Podcast.dart';
import 'package:tuneit/pages/resultPlaylist.dart';
import 'package:tuneit/pages/resultPodcasts.dart';
import 'package:tuneit/pages/resultSongs.dart';

import 'Audio.dart';
import 'Song.dart';

class Searcher extends StatefulWidget {

  final bool musNpod;

  @override
  _SearcherState createState() => _SearcherState(musNpod);

  Searcher(this.musNpod);
}

class _SearcherState extends State<Searcher> {
  TextEditingController editingController = TextEditingController();
  final bool musNpod;

  _SearcherState(this.musNpod);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: TextField(
        onChanged: (value) {
          //filterSearchResults(value);
        },
        controller: editingController,
        decoration: InputDecoration(
          hintText: "Buscador de contenido",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          prefixIcon: IconButton(icon: Icon(Icons.search),iconSize: 30, onPressed: ()async {
            if(musNpod){
              //Compruebo primero las canciones
              List<Song> lista_p = await buscar_canciones(editingController.text);
              // Si no hay ninguna cancion voy a comprobar las listas
              if(lista_p==null || lista_p.isEmpty){
                // Compruebo las listas
                List<Playlist> listaP = await buscar_una_lista(editingController.text);
                if(listaP==null || listaP.isEmpty){
                  //Si no hay nada pues error
                  _showDialog(editingController.text);
                }
                else{
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ResultListPlaylist(list_title: editingController.text,list: listaP,),
                  ));
                }
              }
              else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultSongList(lista_p,editingController.text),
                  ),
                );
              }
            }
            else{
              List<Podcast> lista_p = await fetchPodcastByTitle(editingController.text);
              //Haz que sino encuentra nada devuelva null
              if(lista_p==null|| lista_p.isEmpty){
                _showDialog(editingController.text);
              }
              else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultListPodcast(list_p: lista_p,list_title: editingController.text),
                  ),
                );
              }
            }
          }),
        ),
      ),
    );
  }

  // user defined function
  void _showDialog(String mensaje) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: AlertDialog(
            title: new Text("Error de Busqueda"),
            content: new Text("No se ha encontrado "+ "${mensaje}"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

}


