import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/classes/values/Constants.dart';

import 'Artist.dart';
import 'Song.dart';

class Album {
  String name;
  String description;
  String date;
  String image;
  List<String> artists;
  List<Song> songs;

  Album({this.name, this.description, this.date, this.image,this.artists,this.songs});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['Nombre'],
      description: json['Desc'],
      date: json['fecha'],
      image: json['Imagen'],
      artists: List<String>.from(json['Artistas']),
      songs: json['Canciones'],
    );
  }

  Album initialize () {
    return Album(
        name: '',
        description: '',
        date: '',
        image : '',
        artists: List(),
        songs: List(),
    );
  }

}


Future<Album> searchAlbum(String id) async {
  var queryParameters = {
    'album' : id.toString()
  };

  var uri = Uri.https('psoftware.herokuapp.com','/list_albums_data' , queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad,
  });

  if (response.statusCode == 200) {
    Map<String, dynamic> parsedJson = json.decode(response.body);
    return Album(
        name:parsedJson['Nombre'],
        description:parsedJson['Descripcion'],
        date:parsedJson['fecha'],
        image:parsedJson['Imagen'],
        artists:List(),
        songs:(parsedJson['Canciones'] as List)
            .map((data) => new Song.fromJson(data))
            .toList(),
    );
  } else {
    throw Exception('Failed to load album');
  }
}

