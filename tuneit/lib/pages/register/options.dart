

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/Foto.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/register/mainView.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/textFields.dart';

class opcionesPerfil extends StatefulWidget {
  @override
  _opcionesPerfilState createState() => _opcionesPerfilState();
}

class _opcionesPerfilState extends State<opcionesPerfil> {



  Future<File> la_imagen;
  String base64Image;
  File tmpFile;
  final TextEditingController _controller1 = TextEditingController();
  static final  _formKey_2 = GlobalKey<FormState>();
  final TextEditingController nombre = TextEditingController();
  final TextEditingController password = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final size_width = MediaQuery.of(context).size.width;
    final size_height= MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(),
      drawer: LateralMenu(),

        body:
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                vertical: (25.0), horizontal: 25.0),

            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 3.0, horizontal: 3.0),
              margin: const EdgeInsets.only(left: 15, right: 15),
              width: size_width*0.8,
               height: size_height*0.8,
               child: Form(
                 key: _formKey_2,
                    child: ListView(

                  children: <Widget>[

                      Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Cambiar nombre', style: Theme.of(context).textTheme.subtitle,),
                          ),
                      textField(
                        nombre,
                        false,
                        'aaa',
                        Icons.edit
                        ),


                      SizedBox(height: size_height*0.05,),


                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Cambiar contraseña', style: Theme.of(context).textTheme.subtitle,),
                    ),
                      textField(
                          password,
                        true,
                        'baaa',
                        Icons.edit

                      ),

                      SizedBox(height: size_height*0.05,),

                      Row(children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Seleccionar foto', style: Theme.of(context).textTheme.subtitle,),
                        ),
                        IconButton(icon: Icon(Icons.photo), onPressed: (){
                          setState(() {
                            la_imagen = chooseImage_Gallery();
                          });

                        },),

                        IconButton(icon: Icon(Icons.camera), onPressed: (){
                          setState(() {
                            la_imagen =chooseImage_Camera();
                            print (la_imagen==null);
                          });

                        },),
                      ],),


                      SizedBox(height: size_height*0.05,),
                       Row(
                         children: <Widget>[
                           showImage(),
                         ],
                       ),
                      SizedBox(height: size_height*0.05,),

                     Row(

                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Confirmar cambios', style: Theme.of(context).textTheme.subtitle,),
                        ),
                        SizedBox(width: size_width*0.1,),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)),
                          onPressed: (

                              ) {

                            confirmarCambios( password.text,nombre.text);

                          },
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text("Confirmar".toUpperCase(),
                              style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                    SizedBox(height: size_height*0.05,),

                    Container(
                      width: size_width*0.30,
                      height: size_height*0.2,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(15.0),
                          topRight: const Radius.circular(15.0),
                          bottomLeft: const Radius.circular(15.0),
                          bottomRight: const Radius.circular(15.0),
                        ),
                        border: Border.all(color: ColorSets.colorCritical, width: 2),
                        color: ColorSets.colorDarkCritical,
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10,),
                          Container(
                            width: size_width*0.50,
                            child: textField(_controller1, true, 'Contraseña', Icons.lock_outline),
                          ),
                          SizedBox(height: 10,),
                          criticalButton(context, tryDelete, [], 'Eliminar cuenta', size_width*0.15, size_width*0.15, 15),
                        ],
                      ),
                    ),

                  ],
                ),
               ),

            ),
          ),



    );
  }

  void confirmarCambios( String password, String nombre){
    settingsUser( password,nombre);
    startUploadPhoto(tmpFile, base64Image);
  }

  Widget showImage(){
    return FutureBuilder<File>(
      future: la_imagen,
      builder: (BuildContext context,AsyncSnapshot<File> snapshot){
        print(snapshot.connectionState);
        print(la_imagen);
        if(snapshot.connectionState== ConnectionState.done && snapshot.data!=null){
          tmpFile=snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );

        }
        else if(snapshot.error!=null){
          return const Text(
            'Ha fallado algo',
            textAlign: TextAlign.center,
          );

        }
        else{
          return const Text(
            'No hay imagen loco',
            textAlign: TextAlign.center,
          );

        }
      },
    );
  }


  void tryDelete () {
    setState(() {
      deleteUser(Globals.email, _controller1.text).then((value) async {
        if (value) {

          Globals.isLoggedIn = false;
          Globals.email = '';
          Globals.name = '';
          Globals.password = '';
          Globals.date = '';
          Globals.country = '';
          Globals.image = '';
          Globals.id_fav = '';

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainView()),
          );

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('CUENTA ELIMINADA'),
                  content: Text('Su cuenta ha sido eliminada con éxito'),
                  actions: <Widget>[
                    simpleButton(context, () {Navigator.of(context).pop();}, [], 'Volver')
                  ],
                );
              }
          );
        }
        else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ERROR'),
                  content: Text('Error al eliminar la cuenta'),
                  actions: <Widget>[
                    simpleButton(context, () {Navigator.of(context).pop();}, [], 'Volver')
                  ],
                );
              }
          );
        }
      });
    });
  }


}







