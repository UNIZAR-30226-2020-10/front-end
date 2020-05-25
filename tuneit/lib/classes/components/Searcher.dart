import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/Podcast.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/podcast/resultPodcasts.dart';
import 'package:tuneit/pages/songs/searcherResult.dart';

import 'Album.dart';
import 'Artist.dart';
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
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          searchQuery();
        },
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
                searchQuery();
              }
          ),
        ),
      ),
    );
  }

  void searchQuery () async {
    if(editingController.text.length>=3){


      if(musNpod){
        //Compruebo primero las canciones
        List resultados = await busqueda(editingController.text);
        //List<Song> lista_p = await buscar_canciones(editingController.text);
        List<Playlist> listaP = await buscar_una_lista(editingController.text,Globals.email);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SearcherResult(resultados[0], listaP, resultados[2]),
        ));
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

  Future<List> busqueda(String contenido) async {
    var queryParameters = {
      'nombre' : contenido
    };

    var uri = Uri.https(baseURL,'/search' ,queryParameters);

    final http.Response response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader:Globals.seguridad
    });


    if (response.statusCode == 200) {
      Map<String, dynamic> parsedJson = json.decode(response.body);
      List<Song> list = (parsedJson['Canciones'] as List)
          .map((data) => new Song.fromJson(data))
          .toList();
      List<Album> list2 = (parsedJson['Albums'] as List)
          .map((data) => new Album.fromJson(data))
          .toList();
      List<Artist> list3 = (parsedJson['Artistas'] as List)
          .map((data) => new Artist.fromJson(data))
          .toList();

      return [list,list2,list3];

    } else {

      print('Failed to load playlists');
      return null;
    }
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


