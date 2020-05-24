
import 'dart:convert';
import 'dart:io';

import 'package:tuneit/classes/components/Podcast.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CompartidaPodcast extends Notificacion{

  int id;
  String emisor_nombre;
  User emisor;
  User receptor;
  String podcast;
  bool Notificacion;
  String photo_emisor=Globals.default_image;
  Podcast mi_podcast;
  CompartidaPodcast({this.emisor_nombre,this.podcast,this.emisor,this.receptor,this. photo_emisor,this.id,this.Notificacion});

  void obtenerPodcast()async{
    Podcast podc = await fetchPodcast(podcast);
    mi_podcast=podc;

  }

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

  factory CompartidaPodcast.fromJson(Map<String, dynamic> json){

    User emisor=new User.fromJson(json['Emisor'][0]);
    User receptor=new User.fromJson(json['Receptor'][0]);
    String pod =json['Podcast'];
    print( json['Notificacion']);
    return CompartidaPodcast(
      emisor:emisor,
      receptor: receptor,
      podcast:pod,
      id:json['ID'],
      Notificacion: json['Notificacion'],
    );
  }

}

/***listar podcast compartidos
    list_podcast_compartidos
    Muestra los podcast compartidos con el usuario

    Entrada:
    email: email del usuario cuya información se muestra
    Salida:
    [{"ID": , "Emisor": (info_usuario), "Receptor": (info_usuario), "Podcast": id_serie_podcast, "Notificacion": }, {…}]
    “Error”
    "No existe usuario"
 ***************/

Future<List<CompartidaPodcast>> CompartidosPodcastConmigo() async {

  List<CompartidaPodcast> list;
  var queryParameters = {
    'email' : Globals.email
  };

  var uri = Uri.https(baseURL,'/list_podcast_compartidos' ,queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });


  if (response.statusCode == 200) {
    list = (json.decode(response.body) as List)
        .map((data) => new CompartidaPodcast.fromJson(data))
        .toList();

    for(int i=0;i<list.length;i++){
      list[i].obtenerPodcast();
    }

    return list;

  } else {

    print('Failed to load playlists');
    return [];
  }
}