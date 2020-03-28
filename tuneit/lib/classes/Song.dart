import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Song{
  String title;
  String album;
  List<String> artist;
  String url;
  String id;
  Song({this.title,this.album, this.artist,this.url,this.id});
  // [ {“ID”:, “Nombre” : x, “Artistas”:[], ”Album”: ,”URL”: }, Id2{}, …]

  factory Song.fromJson(Map<String, dynamic> parsedJson) {

    var streetsFromJson  = parsedJson['streets'];
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

  final String id;
  final String name;
  final String description;
  final String image;
  List<Song> songs;

  SongLista({this.id, this.name, this.description, this.image,this.songs});

  factory SongLista.fromJson(Map<String, dynamic> parsedJson) {

    var list = parsedJson['canciones'] as List;
    List<Song> imagesList = list.map((i) =>Song.fromJson(i)).toList();

    return SongLista(
      id:parsedJson['id'],
      name: parsedJson['name'],
      description: parsedJson['description'],
      image: parsedJson['image'],
      songs:imagesList
    );
  }


}

String baseURL="https://psoftware.herokuapp.com/";
Future< SongLista> fetchSonglists(String id) async {
  final response = await http.post(baseURL + '/list_lists', headers: <String, String>{
    'Content-Type': 'application/json'} ,body:jsonEncode(<String,String>{
      'list':id

      }));

  print(response.body);
  if (response.statusCode == 201) {
    return SongLista.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load playlists');
  }
}

