import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/api/messaging.dart';

class  BotonRecomendar extends StatelessWidget {
  String titulo_cancion;
  String mensaje;
  String usuario_recomienda;
  String usuario_recomendado;

  BotonRecomendar({this.usuario_recomendado,this.titulo_cancion,this.mensaje,this.usuario_recomienda});
  @override
  Widget build(BuildContext context) {

    return  IconButton(

          icon: Icon(Icons.send),
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
