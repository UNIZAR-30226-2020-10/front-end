import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tuneit/classes/values/Globals.dart';


const baseURL = 'psoftware.herokuapp.com';

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


  Future<List<Playlist>> fetchPlaylists(String user) async {
  List<Playlist> list = List();

  var queryParameters = {
    'usuario' : user
  };

  var uri = Uri.https('psoftware.herokuapp.com','/list_lists' ,queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });




  if (response.statusCode == 200) {
    list = (json.decode(response.body) as List)
        .map((data) => new Playlist.fromJson(data))
        .toList();

    return list;
  } else {
    throw Exception('Failed to load playlists');
  }
}


Future<List<Playlist>> buscar_una_lista(String data, String user) async {

  List<Playlist> list = List();

  var queryParameters = {
    'lista' : data,
    'usuario':user
  };
  ///search_list

  var uri = Uri.https('psoftware.herokuapp.com','/search_list' ,queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });

  if (response.statusCode == 200) {

    list = (json.decode(response.body) as List)
        .map((data) => new Playlist.fromJson(data))
        .toList();
    return list;

  } else {
    print('Failed to load playlists');
    return null;
  }
}

Future<void> nuevaLista(String nombre, String desc, String email) async {

  final http.Response response = await http.post(
    'https://psoftware.herokuapp.com/create_list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },

    /*        ◦ “list”: nombre de la lista
        ◦ “desc”: descripción*/
    body: jsonEncode(<String, String>{
      'lista': nombre,
      'desc': desc,
      'usuario':email
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.body);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create a new list');
  }

}

Future<void> borrarLista(String id) async {

  print(id);
  final http.Response response = await http.post(
    'https://psoftware.herokuapp.com/delete_list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },


    body: jsonEncode(<String, String>{
      'lista': id,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.body);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create a new list');
  }

}

Future<List<Playlist>> listasUsuario() async {

  List<Playlist> list = List();

  var queryParameters = {
    'usuario' : Globals.email,
  };

  var uri = Uri.https(baseURL,'/list_lists', queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });

  if (response.statusCode == 200) {

    list = (json.decode(response.body) as List)
        .map((data) => new Playlist.fromJson(data))
        .toList();
    return list;

  } else {
    print('Failed to load user playlists');
    return null;
  }
}

