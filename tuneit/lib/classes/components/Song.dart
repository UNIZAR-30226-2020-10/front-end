import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuneit/classes/components/Audio.dart';




class Song extends Audio{
  String name;
  String album;
  List<String> artist;
  String url;
  int id;
  final String image;

  @override
  String devolverSonido(){
    return url;

  }
  @override
  String devolverImagen(){
    return image;
  }

  @override
  String devolverTitulo(){
    return name;
  }

  @override
  String devolverArtista(){
    return juntarArtistas(artist);
  }
  String devolverID(){
    return id.toString();
  }


  String juntarArtistas(List<String> datos){
    String juntitos="";
    for(int i=0;i<datos.length;i++){
      juntitos+=datos[i] + ' ';

    }
    return juntitos;

  }

  Song({this.name,this.album, this.artist,this.url,this.id,this.image});


  factory Song.fromJson(Map<String, dynamic> parsedJson) {

    var streetsFromJson  = parsedJson['Artistas'];

    List<String> losartistas = streetsFromJson.cast<String>();

    return Song(
      id: parsedJson['ID'],
      name: parsedJson['Nombre'],
      album: parsedJson['Album'],
      artist: losartistas,
      url :parsedJson['URL'],
      image: parsedJson['Imagen']
    );
  }

}
const baseURL = 'psoftware.herokuapp.com';

class SongLista{

  final int id;
  final String name;
  final String description;
  final String image;
  List<Song> songs= new List<Song>();

  SongLista({this.id, this.name, this.description, this.image,this.songs});

  factory SongLista.fromJson(Map<String, dynamic> parsedJson) {

    var list = parsedJson['Canciones'] as List;
    List<Song> songsList = list.map((i) =>Song.fromJson(i)).toList();

    return SongLista(
      id: parsedJson['ID'],
      name: parsedJson['Nombre'],
      description: parsedJson['Desc'],
      image: parsedJson['Imagen'],
      songs: songsList
    );
  }


  final _cancionStreamController = StreamController<SongLista>.broadcast();
  Stream<SongLista> get buscar_canciones_1 => _cancionStreamController.stream;


  Future< SongLista> fetchSonglists(String id) async {
    print(id);


    var queryParameters = {
      'list' : id
    };
    var uri = Uri.https(baseURL,'/list_data' ,queryParameters);
    final http.Response response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      _cancionStreamController.sink.add(SongLista.fromJson(json.decode(response.body)));
      return SongLista.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load playlists');
    }
  }


  Future<void> eliminarCancion(String id_lista, String id_song) async {
    final http.Response response = await http.post(
      'https://psoftware.herokuapp.com/delete_from_list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'cancion': id_song,
        'list': id_lista
      }),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to delete a song');
    }

  }

  void agregarCancion( String  id_lista, String id_song) async{

    final http.Response response = await http.post(
      'https://psoftware.herokuapp.com/add_to_list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'cancion': id_song,
        'list': id_lista
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

  }

}


Future< SongLista> fetchSonglists(String id) async {
  print(id);

  var queryParameters = {
    'list' : id
  };
  var uri = Uri.https(baseURL,'/list_data' ,queryParameters);
  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
   // _cancionStreamController.sink.add(SongLista.fromJson(json.decode(response.body)));
    return SongLista.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load playlists');
  }
}


Future<List<Song>> buscar_canciones(String contenido_busqueda) async {

  List<Song> list;
  print(contenido_busqueda);

  var queryParameters = {
    'Nombre' : contenido_busqueda
  };

  var uri = Uri.https(baseURL,'/search' ,queryParameters);

  print(uri);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });


  if (response.statusCode == 200) {

    print(response.body);

    list = (json.decode(response.body) as List)
        .map((data) => new Song.fromJson(data))
        .toList();

    return list;

  } else {

    print('Failed to load playlists');
    return null;
  }
}





