import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


const baseURL = 'https://psoftware.herokuapp.com/list_lists';





class Playlist {
  final int id;
  final String name;
  final String description;
  final String image;

  Playlist({this.id, this.name, this.description, this.image});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['ID'],
      name: json['Nombre'],
      description: json['Desc'],
      image: json['Image'],
    );
  }

}


  Future<List<Playlist>> fetchPlaylists() async {
  List<Playlist> list = List();
  final response = await http.get(baseURL);
  if (response.statusCode == 200) {
    print(response.body);
    list = (json.decode(response.body) as List)
        .map((data) => new Playlist.fromJson(data))
        .toList();

    return list;
  } else {
    throw Exception('Failed to load playlists');
  }
}


Future<List<Playlist>> buscar_una_lista(String data) async {

  List<Playlist> list = List();

  var queryParameters = {
    'Lista' : data
  };

  var uri = Uri.https('psoftware.herokuapp.com','/search_list' ,queryParameters);

  print(uri);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });

  if (response.statusCode == 200) {
    print(response.body);
    list = (json.decode(response.body) as List)
        .map((data) => new Playlist.fromJson(data))
        .toList();

    print("aaaaaaaaaaaaaaa");
    print(list[0].name);

    return list;

  } else {
    print('Failed to load playlists');
    return null;
  }
}






class InitialPlaylist{


  final listas_usuario = StreamController<InitialPlaylist>.broadcast();
  Stream<InitialPlaylist> get seleccionar_listas => listas_usuario.stream;


  List<Playlist> listas=new List<Playlist>();

  InitialPlaylist({this.listas});

  factory InitialPlaylist.fromJson(Map<String, dynamic> parsedJson) {

    var list = parsedJson['Canciones'] as List;
    List<Playlist> songsList = list.map((i) =>Playlist.fromJson(i)).toList();

    return InitialPlaylist(
        listas: songsList
    );
  }

  Future<void> fetchNewList() async {
    List<Playlist> list = List();
    final response = await http.get(baseURL);
    if (response.statusCode == 200) {
      print(response.body);

      print("aaaaaaaa");

      list = (json.decode(response.body) as List)
          .map((data) => new Playlist.fromJson(data))
          .toList();
      InitialPlaylist odin = new InitialPlaylist(listas: list);
      print (odin.listas[0].name);

      listas_usuario.sink.add(odin);
    } else {
      throw Exception('Failed to load playlists');
    }
  }






}
