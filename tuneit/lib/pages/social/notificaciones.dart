import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuneit/model/message.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';


class Notificaciones extends StatefulWidget{

  @override
  _NotificacionesState createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  final List<Message> messages = [];

  Message ultimo_add=new Message(title: 'Nada', body: 'Nada');


  Future<void> fillthemesages ( ) async{


//###################################################################
  //Aqui leeriamos de nuestra base de datos los mensajes anteriores
    // ###################################################################




  }


  void ObtenerDatos() async{
    await fillthemesages();
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if(arguments!= null){
      setState(() {
        messages.add(new Message(title: arguments['title'], body:  arguments['body']));
      });
    }

  }


  @override
  void initState(){
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
      body:  ListView.builder(
            itemCount: messages.length,
            itemBuilder:( context,index){
              return Card(
                child: ListTile(
                  onTap:(){

                //Implementar que cuando pulse en el mensaje vaya al perfil de la cancion
                  },

                  /*leading: CircleAvatar(
                    backgroundImage: NetworkImage(),

                  ),*/
                  title: Text('${messages[index].title}'),

                  subtitle: Text('${messages[index].body}'),


                ),
              );
            }
    ),
      bottomNavigationBar: bottomExpandableAudio(),
    );
  }
}

