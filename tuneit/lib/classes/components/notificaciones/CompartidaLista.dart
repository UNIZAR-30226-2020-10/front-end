import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/values/Constants.dart';

import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/Globals.dart';

import '../Song.dart';
import '../User.dart';

class CompartidaLista extends Notificacion{

  int id;
  String emisor_nombre;
  User emisor;
  User receptor;
  Playlist lista;
  bool Notificacion;
  String photo_emisor=Globals.default_image;
  CompartidaLista({this.emisor_nombre,this.lista,this.emisor,this.receptor,this. photo_emisor,this.id,this.Notificacion});


  //[{"Id": , "Emisor": email, "Receptor": email}, {…}]

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

  factory CompartidaLista.fromJson(Map<String, dynamic> json) {
    User emisor=new User.fromJson(json['Emisor'][0]);
    User receptor=new User.fromJson(json['Receptor'][0]);
    Playlist list=new Playlist.fromJson(json['Listas']);
    return CompartidaLista(
      emisor:emisor,
      receptor: receptor,
      lista:list,
      id:json['ID'],
      Notificacion: json['Notificacion'],
    );
  }

}