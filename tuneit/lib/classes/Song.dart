import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Song{
  String title;
  String album;
  List<String> artist;
  String url;
  int id;
  Song({this.title,this.album, this.artist,this.url,this.id});
  // [ {“ID”:, “Nombre” : x, “Artistas”:[], ”Album”: ,”URL”: }, Id2{}, …]

  factory Song.fromJson(Map<String, dynamic> parsedJson) {

    var streetsFromJson  = parsedJson['Artistas'];
    //print(streetsFromJson.runtimeType);
    // List<String> streetsList = new List<String>.from(streetsFromJson);
    List<String> losartistas = streetsFromJson.cast<String>();

    return Song(
      id: parsedJson['ID'],
      title: parsedJson['Nombre'],
      album: parsedJson['Album'],
      artist: losartistas,
      url :parsedJson['URL'],
    );
  }

}

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


}

const baseURL = 'psoftware.herokuapp.com';
Future< SongLista> fetchSonglists(String id) async {
  var queryParameters = {
    'list' : id
  };
  var uri = Uri.https(baseURL,'/list_data' ,queryParameters);
  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  print(response.body);
  List <dynamic> datos =json.decode(response.body);
  if (response.statusCode == 200) {
    return SongLista.fromJson(datos[0]);
  } else {
    throw Exception('Failed to load playlists');
  }
}

