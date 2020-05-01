

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/Foto.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/textFields.dart';

class opcionesPerfil extends StatefulWidget {
  @override
  _opcionesPerfilState createState() => _opcionesPerfilState();
}

class _opcionesPerfilState extends State<opcionesPerfil> {



  Future<File> la_imagen;
  String base64Image;
  File tmpFile;


  @override
  Widget build(BuildContext context) {
    //queryData.size.width


    final _formKey_2 = GlobalKey<FormState>();
    final size_width = MediaQuery.of(context).size.width;
    final size_height= MediaQuery.of(context).size.height;
    final TextEditingController nombre = TextEditingController();
    final TextEditingController password = TextEditingController();
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,

                  //crossAxisCount: 2,
                  children: <Widget>[

                      Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Cambiar nombre', style: Theme.of(context).textTheme.subtitle,),
                          ),
                      textField(
                        nombre,
                        false,
                        '',
                        Icons.edit
                        ),


                      SizedBox(height: size_height*0.05,),




                    //(TextEditingController _controller, bool obscureText, String text, IconData ic)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Cambiar contraseña', style: Theme.of(context).textTheme.subtitle,),
                    ),
                      textField(
                          password,
                        true,
                        '',
                        Icons.edit

                      ),
                      //SizedBox(height: size_height*0.05,),


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
                       showImage(),
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


}




