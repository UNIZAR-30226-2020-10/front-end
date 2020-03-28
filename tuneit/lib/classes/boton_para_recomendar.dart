import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/api/messaging.dart';

class  Boton_recomendar extends StatelessWidget {
  String titulo_cancion;
  String mensaje;
  String usuario_recomienda;
  String usuario_recomendado;

  Boton_recomendar({this.usuario_recomendado,this.titulo_cancion,this.mensaje,this.usuario_recomienda});
  @override
  Widget build(BuildContext context) {

    return  IconButton(

          icon: Icon(Icons.volume_up),
          tooltip: 'Increase volume by 10',
          onPressed: sendNotification
       );
  }


  Future sendNotification() async {
    await Messaging.sendToAll(
        title: titulo_cancion,
        body: mensaje,
      // fcmToken: fcmToken,
    );


    /*await Messaging.sendTo(
      title: titulo_cancion,
      body: mensaje,
      fcmToken: usuario_recomendado
      // fcmToken: fcmToken,
    );*/

  }
}
