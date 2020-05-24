import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:tuneit/api/messaging.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaCancion.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaLista.dart';
import 'package:tuneit/classes/components/notificaciones/Peticion.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:http/http.dart' as http;

abstract class Notificacion{
  String devolverEmisor();
  String devolverMensaje();
  String devolverImagen();
  int devolverID();
}
Future sendNotification(String titulo,String cuerpo, String token_usuario) async {
  await Messaging.sendTo(
      title: titulo,
      body: cuerpo,
      fcmToken: token_usuario
    // fcmToken: fcmToken,
  );

}


Future<void>desNotificarLista(List<Notificacion> lista,String url){
  for(int i=0;i<lista.length;i++){
    desNotificar(lista[i],url);
  }
}

Future<void> desNotificar(Notificacion noti,String url)async {

    var queryParameters = {
      'elemento':noti.devolverID().toString()
    };

    var uri = Uri.https(baseURL,url ,queryParameters);
    print(uri);

    final http.Response response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader:Globals.seguridad
    });
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 ) {

      return true;

    } else {

      print('Error al dejar de notificar '+ url);
      return false;
    }

}



Future <int> contarNotificaciones()async {
  List<Peticion> prueba = await buscarPeticiones();
  List<CompartidaCancion> canciones=await canciones_compartidas_conmigo();
  List<CompartidaLista>  listas=await listasCompartidas();
  int contador=0;
  for(int i=0;i<prueba.length;i++){
      contador++;

  }

  for(int i=0;i<canciones.length;i++){
    if(canciones[i].Notificacion){
      contador++;
    }
  }

  for(int i=0;i<listas.length;i++){
    if(listas[i].Notificacion){
      contador++;
    }
  }

  return contador;
}
