import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'Album.dart';

class Artist {
  String name = '';
  String alias = '';
  String country = '';
  String date = '';
  List<Album> albums = List();
  String image = 'https://i.blogs.es/6c558d/luna-400mpx/450_1000.jpg';

  Artist({this.name,this.alias,this.country,this.date,this.albums});

  factory Artist.fromJson(Map<String, dynamic> parsedJson) {
    return Artist(
      name: parsedJson['Nombre'],
      alias: parsedJson['alias'],
      country: parsedJson['Pais'],
      date: parsedJson['fecha'],
      albums: parsedJson['Albumes'],
    );
  }

}

const baseURL = 'psoftware.herokuapp.com';

Future<List<Artist>> listArtists () async{
  List<Artist> list = List();

  var uri = Uri.https(baseURL,'/list_artists' , null);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });

  if (response.statusCode == 200) {
    list = (json.decode(response.body) as List)
        .map((data) => new Artist.fromJson(data))
        .toList();

    return list;
  }
  else {
    throw Exception('Failed to load artists');
  }
}

Future<Artist> artistByName (String name) async{
  var queryParameters = {
    'artista' : name
  };
  var uri = Uri.https(baseURL,'/list_artist_data' , queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });

  if (response.statusCode == 200) {
    Map<String, dynamic> parsedJson = json.decode(response.body);

    return Artist(
      name: parsedJson['Nombre'] == null? 'Nombre es null' : parsedJson['Nombre'],
      alias: parsedJson['alias'] == null? '' : parsedJson['Nombre'],
      country: parsedJson['Pais'] == null? 'Pais es null' : parsedJson['Pais'],
      date: parsedJson['fecha'] == null? 'Fecha desconocida' : parsedJson['fecha'],
      albums:
        (parsedJson['Albumes'] as List)
            .map((data) => new Album.fromJson(data))
            .toList()
    );
  }
  else {
    throw Exception('Failed to load artist by name');
  }
}
