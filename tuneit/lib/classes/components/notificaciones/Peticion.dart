import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/Constants.dart';

import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/Globals.dart';

import '../User.dart';

class Peticion extends Notificacion{

  int id;
  String emisor_nombre;
  String emisor_email;
  String photo_emisor=Globals.default_image;
  bool Notificacion;
  Peticion({this.emisor_nombre,this.emisor_email,this. photo_emisor,this.id,this.Notificacion});


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

  factory Peticion.fromJson(Map<String, dynamic> json) {
    List<dynamic> prueba1=json['Emisor'];
    Map emisormap=prueba1[0];


    return Peticion(
      emisor_nombre:emisormap['Nombre'],
      emisor_email: emisormap['Email'],
      photo_emisor:emisormap['Imagen'],
      id:json['ID'],
      Notificacion: json['Notificacion'],
    );
  }

}

Future<List<Peticion>> buscarPeticiones() async {
  List<Peticion> list=[];
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

/**

    Eliminar amigo /delete_friend

    Entrada:
    email: email del usuario
    amigo: email del amigo a eliminar
    Salida:
    "Success"
    "No existe usuario"
    "No existe amigo"
    "Error"
*/

Future<bool> deleteFriend(String email,String amigo) async {

  bool exito=false;
  final http.Response response = await http.post(
    'https://' + baseURL + '/delete_friend',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email' : email,
      'amigo':amigo,
    }),
  );


  if (response.statusCode == 200) {
    exito=true;

  } else {
    print(response.body + ': problema al borrar amigo');

  }
  return exito;
}



Future<bool> reactNotificacion(String id,String respuesta) async {

  bool exito=false;

  final http.Response response = await http.post(
    'https://' + baseURL + '/responder_peticion',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'peticion' : id,
      'respuesta':respuesta,
    }),
  );

  if (response.statusCode == 200) {
   exito=true;

  } else {
    print(response.body + ': problema al '+respuesta);

  }
  return exito;
}