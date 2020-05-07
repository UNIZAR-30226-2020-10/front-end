import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/components/notificaciones/Peticion.dart';
import 'package:tuneit/model/message.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';


class Notificaciones extends StatefulWidget{

  @override
  _NotificacionesState createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
   List<Peticion> peticiones = [];





  void ObtenerDatos() async {
    List<Peticion> prueba = await buscarPeticiones();
    print(prueba.length);
    setState(() {
      peticiones=prueba;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    ObtenerDatos();
    super.initState();

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
      body: Column(children:listaParaNotificaciones(context,peticiones)),

      bottomNavigationBar: bottomExpandableAudio(),
    );
  }

}


  List<Widget> listaParaNotificaciones(BuildContext context,List<Notificacion> list){
  print(list.length);
    if(list.length>0){
      return List.generate(
        list.length,
            (index) {
          return
            Card(
              key: Key('$index'),
              child: new ListTile(
                onTap:(){

                },
                title: Text(list[index].devolverMensaje()),
                subtitle: Text(list[index].devolverEmisor()),
                /*trailing: PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context){
                    return optionMenuSong.map((String choice){
                      return PopupMenuItem<String>(
                        value: (choice + "--"+audios[index].devolverID().toString()+"--"+indetificadorLista+"--"+index.toString()),
                        child: Text(choice),
                      );

                    }).toList();
                  },
                ),*/
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

