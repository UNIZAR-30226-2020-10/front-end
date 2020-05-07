import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/Globals.dart';

class Peticion extends Notificacion{
  String emisor;
  String receptor;
  String id;
  Peticion({this.emisor,this.receptor,this.id});

  //[{"Id": , "Emisor": email, "Receptor": email}, {…}]

  String devolverEmisor(){
    return emisor;

  }
  String devolverReceptor(){
    return receptor;

  }
  String devolverMensaje(){
    return "El usario "+ emisor+" quiere ser tu amigo";

  }

  factory Peticion.fromJson(Map<String, dynamic> json) {
    return Peticion(
     emisor: json['Emisor'].toString(),
      receptor: json['Receptor'].toString(),
      id:json['Id'].toString(),
    );
  }

}

const baseURL = 'psoftware.herokuapp.com';
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