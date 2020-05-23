import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/Constants.dart';

import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/Globals.dart';

import '../Song.dart';
import '../User.dart';

class CompartidaCancion extends Notificacion{

  int id;
  String emisor_nombre;
  User emisor;
  User receptor;
  Song cancion;
  bool Notificacion;
  String photo_emisor=Globals.default_image;
  CompartidaCancion({this.emisor_nombre,this.cancion,this.emisor,this.receptor,this. photo_emisor,this.id,this.Notificacion});


  String devolverEmisor(){
    return emisor_nombre;

  }

  int devolverID(){
    return id;
  }

  String devolverMensaje(){
    String des="Quiere ser tu amigo: ";
    des+=emisor_nombre;
    return des;

  }

  String devolverImagen(){
    return photo_emisor;
  }

  factory CompartidaCancion.fromJson(Map<String, dynamic> json) {
    User emisor=new User.fromJson(json['Emisor'][0]);
    User receptor=new User.fromJson(json['Receptor'][0]);
    Song song=new Song.fromJson(json['Cancion']);
    return CompartidaCancion(
      emisor:emisor,
      receptor: receptor,
      cancion:song,
      id:json['ID'],
      Notificacion: json['Notificacion'],
    );
  }

}

/*list_canciones_compartidas_conmigo
Devuelve la lista de canciones compartidas a un usuario

Entrada:
email: email del usuario cuya información se muestra
Salida:
[{"ID": , "Emisor": (info_usuario), "Receptor": (info_usuario), "Cancion": (list_song_data)}, {…}]
“Error”
"No existe usuario"
*/

Future<List<CompartidaCancion>> canciones_compartidas_conmigo() async {

  List<CompartidaCancion> list;
  var queryParameters = {
    'email' : Globals.email
  };

  var uri = Uri.https(baseURL,'/list_canciones_compartidas_conmigo' ,queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });


  if (response.statusCode == 200) {
    list = (json.decode(response.body) as List)
        .map((data) => new CompartidaCancion.fromJson(data))
        .toList();

    return list;

  } else {

    print('Failed to load playlists');
    return [];
  }
}

/*Dejar de compartir cancion /unshare_song
Elimina la compartición de una cancion

    Entrada
        song: id de la cancion_compartida, no id de cancion
    Salida
        "No existe": no existe la compartición a eliminar
        "Error"
        "Success"
*/

Future<bool> canciones_compartidas_eliminar(String id) async {

  var queryParameters = {
    'cancion':id
  };

  var uri = Uri.https(baseURL,'/unshare_song' ,queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });


  if (response.statusCode == 200 && response.body=="Success") {

    return true;

  } else {
    print(response.statusCode);
    print(response.body);

    print('Failed to delete recomendation');
    return false;
  }
}