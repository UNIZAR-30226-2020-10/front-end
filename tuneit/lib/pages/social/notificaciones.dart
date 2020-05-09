import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/components/notificaciones/Peticion.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/model/message.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/bottomExpandableAudio.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/errors.dart';


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
    Globals.mensaje_nuevo=false;
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final size_width = MediaQuery.of(context).size.width;
    final size_height= MediaQuery.of(context).size.height;
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
      body: ListView(children:listaParaNotificaciones(context,peticiones,size_width,size_height)),

      bottomNavigationBar: bottomExpandableAudio(),
    );
  }

}


  List<Widget> listaParaNotificaciones(BuildContext context,List<Notificacion> list,anchura,altura){
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
                leading: GFAvatar(

                  backgroundImage: NetworkImage(list[index].devolverImagen()),
                  backgroundColor: Colors.transparent,
                  shape: GFAvatarShape.standard,

                ),
                title: Text(list[index].devolverMensaje()),
                subtitle: Text(list[index].devolverEmisor()),


                trailing: Container(
                  width: anchura*0.25,
                  height: altura*0.25,
                  child: Row(
                      children: <Widget>[
                           IconButton(
                             color:Colors.green,
                            onPressed: () async {
                              bool prueba= await reactNotificacion(list[index].devolverID().toString(),'Acepto');
                              if(prueba){
                                _operacionExito(context);

                              }
                              else{
                                mostrarError(context,'No se ha podido aceptar la petición');

                              }
                            },
                            icon:Icon(Icons.check_circle),
                             tooltip: aceptar_mensaje,
                          ),
                        IconButton(

                            color:Colors.red,
                            onPressed: () async {
                              bool prueba= await reactNotificacion(list[index].devolverID().toString(),'Rechazo');
                              if(prueba){
                                _operacionExito(context);


                              }
                              else{

                                mostrarError(context,'No se ha podido rechazar la petición');

                              }

                            },
                            icon:Icon(Icons.cancel),
                            tooltip: rechazar_mensaje,
                          ),

                      ],
                  ),
                ),
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
void _operacionExito(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(exito_mensaje),
        content: new Text("Operacion realizada de forma exitosa"),
        actions: <Widget>[
          simpleButton(context, () {Navigator.of(context).pop();
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Notificaciones(),
          ));}, [], 'Confirmar')
        ],

      );
    },
  );
}
