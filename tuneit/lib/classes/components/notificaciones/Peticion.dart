import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/Constants.dart';

import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/Globals.dart';

import '../User.dart';

class Peticion extends Notificacion{

  String id;
  String emisor_nombre;
  String emisor_email;
  String photo_emisor=Globals.default_image;
  Peticion({this.emisor_nombre,this.emisor_email,this. photo_emisor,this.id});


  //[{"Id": , "Emisor": email, "Receptor": email}, {…}]

  String devolverEmisor(){
    return emisor_nombre;

  }

  String devolverMensaje(){
    String des="Quiere ser tu amigo: ";
    des+=emisor_nombre;
    return des;

  }

  String devolverImagen(){
    return photo_emisor;
  }

  factory Peticion.fromJson(Map<String, dynamic> json) {
    List<dynamic> prueba1=json['Emisor'];
    Map emisormap=prueba1[0];
    print(emisormap);
    return Peticion(
      emisor_nombre:emisormap['Nombre'],
      emisor_email: emisormap['Email'],
      photo_emisor:emisormap['Imagen'],
      id:json['Id'],
    );
  }

}

Future<List<Peticion>> buscarPeticiones() async {
  List<Peticion> list=[];
//email: email del usuario cuya información se muestra
  var queryParameters = {
    'email' : Globals.email,
  };
  var uri = Uri.http(baseURL, '/list_peticiones_recibidas', queryParameters);
  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  if(response.statusCode==200){


    list = (json.decode(response.body) as List)
        .map((data) => new Peticion.fromJson(data))
        .toList();


    print(list.length);

  }
  else{
    print("No se han encontrado resultados para amigos");
    print(response.statusCode);

  }

  return list;


}