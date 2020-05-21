import 'package:flutter/cupertino.dart';
import 'package:tuneit/api/messaging.dart';
import 'package:tuneit/classes/components/Playlist.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaCancion.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaLista.dart';
import 'package:tuneit/classes/components/notificaciones/Peticion.dart';

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


Future <int> contarNotificaciones()async {
  List<Peticion> prueba = await buscarPeticiones();
  List<CompartidaCancion> canciones=await canciones_compartidas_conmigo();
  List<CompartidaLista>  listas=await listasCompartidas();
  int contador=0;
  for(int i=0;i<prueba.length;i++){

    if(prueba[i].Notificacion){
      contador++;
    }
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
