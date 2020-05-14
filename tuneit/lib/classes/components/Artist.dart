import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'Album.dart';

class Artist {
  String name = '';
  String alias = '';
  String country = '';
  String date = '';
  List<Album> albums = List();
  String image = 'https://i.blogs.es/6c558d/luna-400mpx/450_1000.jpg';

  Artist({this.name,this.alias,this.country,this.date,this.albums,this.image});

  factory Artist.fromJson(Map<String, dynamic> parsedJson) {
    //{Imagen: https://psoftware.s3.amazonaws.com/alan_walker.jpg, Nombre: Alan Walker, Pais: null}
    print(parsedJson);
    return Artist(
      name: parsedJson['Nombre'],
      alias: parsedJson['alias'],
      country: parsedJson['Pais'],
      date: parsedJson['fecha'],
      albums: parsedJson['Albumes'],
      image:parsedJson['Imagen'],
    );
  }

}


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
        image: parsedJson['Imagen'] == null? 'https://i.blogs.es/6c558d/luna-400mpx/450_1000.jpg' : parsedJson['Imagen'],
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

Future<List<Artist>> fetchMyArtists (String email) async{
  List<Artist> list = List();
  var queryParameters = {
    'email' : email
  };

  var uri = Uri.https(baseURL,'/list_suscriptions' , queryParameters);

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
    throw Exception('Failed to load subscribed artists');
  }
}

Future<void> isFav(String id) async {

  final http.Response response = await http.post(
    'https://' + baseURL + '/suscription',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'artista' : id,
      'email' : Globals.email,
    }),
  );

  if (response.body != 'Success') {
    throw Exception(response.body + ': Failed to subscribe artist');
  }
}

Future<void> isNotFav(String id) async {
  final http.Response response = await http.post(
    'https://' + baseURL + '/unsuscribe',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'artista' : id,
      'email' : Globals.email,
    }),
  );

  if (response.body != 'Success') {
    throw Exception(response.body + ': Failed to unsubscribe artist');
  }
}

Future<bool> checkFav(String id) async {
  var queryParameters = {
    'email' : Globals.email,
  };
  var uri = Uri.http(baseURL, '/list_suscriptions', queryParameters);
  final http.Response response = await http.get(uri);

  if (response.body != 'Error') {
    List<String> list = (json.decode(response.body) as List)
        .map((data) => new Artist.fromJson(data).name)
        .toList();

    return list.contains(id);
  }
  else {
    throw Exception(response.body + ': Failed to check suscribed artists');
  }
}

