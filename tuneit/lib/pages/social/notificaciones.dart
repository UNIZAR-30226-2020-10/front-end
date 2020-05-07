import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:tuneit/classes/components/Notificacion.dart';
import 'package:tuneit/model/message.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';


class Notificaciones extends StatefulWidget{

  @override
  _NotificacionesState createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  final List<Message> messages = [];

  Message ultimo_add = new Message(title: 'Nada', body: 'Nada');


  Future<void> fillthemesages() async {
//###################################################################
    //Aqui leeriamos de nuestra base de datos los mensajes anteriores
    // ###################################################################


  }


  void ObtenerDatos() async {
    await fillthemesages();
  }


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    ObtenerDatos();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Notificaciones'),
        centerTitle: true,
      ),
      drawer: LateralMenu(),
      body: Container(),

      bottomNavigationBar: bottomExpandableAudio(),
    );
  }

}


  /*List<Widget> listaParaNotificaciones(BuildContext context,List<Notificacion> amigos){
    if(amigos.length>0){
      return List.generate(
        amigos.length,
            (index) {
          return
            Card(
              key: Key('$index'),
              child: new ListTile(
                onTap:(){

                },

                leading: GFAvatar(

                  backgroundImage: NetworkImage(amigos[index].photo),
                  backgroundColor: Colors.transparent,
                  shape: GFAvatarShape.standard,

                ),
                title: Text(amigos[index].name),
                subtitle: Text(amigos[index].date),

              ),
            );

        },
      );
    }


    else{
      return  <Widget>[

        Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("No encontrados amigos"),
        ))

      ];
    }


  }
}*/

