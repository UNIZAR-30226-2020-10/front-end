

import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Podcast.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/songs/resultPlaylist.dart';
import 'package:tuneit/pages/podcast/resultPodcasts.dart';
import 'package:tuneit/pages/songs/resultSongs.dart';

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
        color: Colors.white10,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: TextField(
        //minLines: 3,
        onChanged: (value) {
          //filterSearchResults(value);
        },
        controller: editingController,
        decoration: InputDecoration(

          hintText: "Buscar contenido",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          prefixIcon: IconButton(
              icon: Icon(Icons.search, color: Colors.white70,),
              iconSize: 30,
              onPressed: ()async {
                if(editingController.text.length>=3){


                  if(musNpod){
                    //Compruebo primero las canciones
                    List<Song> lista_p = await buscar_canciones(editingController.text);
                    // Si no hay ninguna cancion voy a comprobar las listas
                    if(lista_p==null || lista_p.isEmpty){
                      // Compruebo las listas
                      List<Playlist> listaP = await buscar_una_lista(editingController.text,Globals.email);
                      if(listaP==null || listaP.isEmpty){
                        //Si no hay nada pues error
                        _notFound(editingController.text);
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
                    List<Podcast> listaPodcasts = await fetchPodcastByTitle(editingController.text);
                    //Haz que sino encuentra nada devuelva null
                    if(listaPodcasts==null|| listaPodcasts.isEmpty){
                      _notFound(editingController.text);
                    }
                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPodcasts(listaPodcasts, editingController.text),
                        ),
                      );
                    }
                  }
                }
                else{
                  _notBigEnough();


                }
              }
          ),
        ),
      ),
    );
  }

  // user defined function
  void _notFound(String mensaje) {
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

  void _notBigEnough() {
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
            content: new Text("La búsqueda ha de tener mínimo 3 caracteres"),
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


