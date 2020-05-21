

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:encrypt/encrypt.dart' as Encrypter;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/Foto.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/register/mainView.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/errors.dart';
import 'package:tuneit/widgets/pais.dart';
import 'package:tuneit/widgets/textFields.dart';

class opcionesPerfil extends StatefulWidget {
  @override
  _opcionesPerfilState createState() => _opcionesPerfilState();
}

class _opcionesPerfilState extends State<opcionesPerfil> {



  Future<File> la_imagen;
  String base64Image=null;
  File tmpFile=null;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController nombre = TextEditingController();
  final TextEditingController password = TextEditingController();

  String pais = Globals.country;


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
                    child: ListView(

                  children: <Widget>[

                      Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Cambiar nombre', style: Theme.of(context).textTheme.subtitle,),
                          ),
                      textField(
                        nombre,
                        false,
                        'Cambie su nombre',
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
                        'Cambie su contraseña',
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


                     widget_paises(countryDrop()),

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
                            confirmarCambios(context,password.text,nombre.text,pais,tmpFile,base64Image);

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



    );
  }

  Widget countryDrop () {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          hint: Text(pais),
          icon: Icon(null),
          style: TextStyle(
            color: ColorSets.colorText,
            fontSize: 15,
          ),
          onChanged: (String value) {
            setState(() {
              pais = value;
            });
          },
          items: Paises()
      ),
    );
  }



  void confirmarCambios(BuildContext context, String password, String nombre, String pais,File tmpFile , String base64Image){
    startUploadPhoto(tmpFile , base64Image);
   /* if(nombre!="" && (nombre.length < 3 || nombre.length > 50)){
      mostrarError(context,'Tu nuevo nombre de usuario debe contener entre 3 y 50 carácteres');
    }
    else if (password!="" && (password.length < 7 && password.length > 0)){
      mostrarError(context,'Tu constraseña debe ser de más de 7 carácteres');
    }
    else if(password!="" && !password.contains(new RegExp(r'^[a-zA-Z]*[0-9][0-9a-zA-Z]*$'))){
      mostrarError(context,'Tu constraseña debe tener como mínimo 1 número y '
          'solo se aceptan minúsculas, mayúsculas y números ');
    }
    else {
      formularioContrasegna(context,password,nombre,pais);
      if(tmpFile!=null && base64Image!=null){
        startUploadPhoto(tmpFile , base64Image);
      }

    }*/
  }

  Widget showImage(){
    return FutureBuilder<File>(
      future: la_imagen,
      builder: (BuildContext context,AsyncSnapshot<File> snapshot){

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
            'No hay imagen',
            textAlign: TextAlign.center,
          );

        }
      },
    );
  }


  void tryDelete () {
    final key = Encrypter.Key.fromUtf8('KarenSparckJonesProyectoSoftware');
    final iv = Encrypter.IV.fromLength(16);
    final encrypter = Encrypter.Encrypter(Encrypter.AES(key,mode: Encrypter.AESMode.ecb));
    final encrypted = encrypter.encrypt(_controller1.text, iv: iv);
    setState(() {
      deleteUser(Globals.email, encrypted.base64).then((value) async {
        if (value) {

          Globals.isLoggedIn = false;
          Globals.email = '';
          Globals.name = '';
          Globals.password = '';
          Globals.date = '';
          Globals.country = '';
          Globals.image = '';
          Globals.id_fav = '';

          final prefs = await SharedPreferences.getInstance();
          prefs.setString('user', '0');
          prefs.setString('password', '0');

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
  bool comprarContreynas( String password){
    if(password!="" && password!=null){
      final key = Encrypter.Key.fromUtf8('KarenSparckJonesProyectoSoftware');
      final iv = Encrypter.IV.fromLength(16);
      final encrypter = Encrypter.Encrypter(Encrypter.AES(key,mode: Encrypter.AESMode.ecb));
      final encrypted = encrypter.encrypt(password, iv: iv);

      return (Globals.password==encrypted.base64);

    }
    else{
      return false;
    }


    //settingsUser(encrypted.base64, nombre, pais);
    //startUploadPhoto(tmpFile, base64Image);
  }

  void formularioContrasegna (BuildContext context,String passprueba, String nombre,String pais) {
    // flutter defined functio
    final TextEditingController confirmar_password = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },

          child: AlertDialog(
            title: Text(
              'Confirmar cambio',
              style: Theme.of(context).textTheme.title,
            ),

            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Repita su antigua contraseña para confirmar el cambio. Recuerde que los campos vacíos no se modificarán.'),
                textField(confirmar_password,true,"Contraseña antigua",Icons.edit),
              ],
            ),
            actions: <Widget>[
              //SizedBox(height: 15,),
              RaisedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if(comprarContreynas(confirmar_password.text)){
                    settingsUser(passprueba, nombre, pais);
                    operacionExito(context);

                  }
                  else{
                    mostrarError(context,"Contraseña incorrecta");
                  }



                },
                color: ColorSets.colorBlue,
                child: Text("Confirmar"),
              ),
              simpleButton(context, () {Navigator.of(context).pop();}, [], 'Volver')

            ],

          ),

        );
      },
    );
  }





}













