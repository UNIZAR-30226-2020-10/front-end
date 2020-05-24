

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:encrypt/encrypt.dart' as Encrypter;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/Foto.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/register/mainView.dart';
import 'package:tuneit/widgets/AutoScrollableText.dart';
import 'package:tuneit/widgets/LateralMenu.dart';
import 'package:tuneit/widgets/TuneITProgressIndicator%20.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/errors.dart';
import 'package:tuneit/widgets/lists.dart';
import 'package:tuneit/widgets/pais.dart';
import 'package:tuneit/widgets/textFields.dart';

class opcionesPerfil extends StatefulWidget {
  @override
  _opcionesPerfilState createState() => _opcionesPerfilState();
}

class _opcionesPerfilState extends State<opcionesPerfil> {




  List<Foto> imagenes=[];
  String base64Image=null;
  File tmpFile=null;
  String fighter=null;
  String imagen=Globals.image;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController nombre = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> obtenerDatos() async{
   List<Foto> DATOS= await listasImagenes();
    setState(() {
      imagenes=DATOS;
    });
  }

  String pais = Globals.country;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerDatos();


  }


  @override
  Widget build(BuildContext context) {
    final size_width = MediaQuery.of(context).size.width;
    final size_height= MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(),
      body:
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                vertical: (15.0), horizontal: 15.0),

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
                            child: Text('Cambiar su nombre', style: Theme.of(context).textTheme.subtitle,),
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
                        child: Text('Cambiar su contraseña', style: Theme.of(context).textTheme.subtitle,),
                    ),
                      textField(
                          password,
                        true,
                        'Cambie su contraseña',
                        Icons.edit

                      ),

                      SizedBox(height: size_height*0.05,),

                    ListTile(
                      title:           Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Cambiar su foto de perfil', style: Theme.of(context).textTheme.subtitle,),
                      ),

                    ),
                    Container(
                         height:200,
                         width:300,
                         child: completeListHorizontalFotos (imagenes,size_width,size_height)),


                      SizedBox(height: size_height*0.05,),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Cambiar su país', style: Theme.of(context).textTheme.subtitle,),
                    ),


                     widget_paises(countryDrop()),

                      SizedBox(height: size_height*0.05,),

                      ListTile(
                          title:                 Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Confirmar cambios', style: Theme.of(context).textTheme.subtitle,),
                          ),  // Text('Confirmar cambios'),

                          trailing:        RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white)),
                            onPressed: (

                                ) {
                              confirmarCambios(context,password.text,nombre.text,pais,fighter,imagen);

                            },
                            color: Colors.deepPurple,
                            textColor: Colors.white,
                            child: Text("Confirmar".toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                          ) ,

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

  void SeleccionarImagen(BuildContext context,String imagen_p, String id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("¿Quiere seleccionar esta imagen?"),
          content: new Image(
          image: imagen_p== null? new AssetImage(imagenPorDefecto) : new NetworkImage(imagen_p),
          fit: BoxFit.cover,
        ),
          actions: <Widget>[
            simpleButton(context, () {

              setState(() {
                fighter=id;
                imagen=imagen_p;
              });
              print(fighter);

              Navigator.of(context).pop();
              }, [], 'Confirmar'),
            simpleButton(context, () {
              setState(() {
                fighter=null;
              });

              Navigator.of(context).pop();}, [], 'Cancelar'),
          ],

        );
      },
    );
  }

  Widget completeListHorizontalFotos (List<Foto> lista,size_width,size_height) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
        itemCount: lista.length,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {

              SeleccionarImagen(context,lista[index].image, lista[index].id.toString());

            },
            child:new Container(
              height: size_height*.005,
              width: size_width*0.35,
              decoration: new BoxDecoration(
                  color: Colors.white10,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    topRight: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0),
                  )
              ),
              child: Center(
                  child: Column(
                      children: <Widget>[
                        Flexible(
                            flex: 6,
                            child: new Container(
                              margin: EdgeInsets.all(10.0),
                              decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: new DecorationImage(
                                    image: lista[index].image== null? new AssetImage(imagenPorDefecto) : new NetworkImage(lista[index].image),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(8.0),
                                    topRight: const Radius.circular(8.0),
                                    bottomLeft: const Radius.circular(8.0),
                                    bottomRight: const Radius.circular(8.0),
                                  )
                              ),
                            )
                        ),
                        Flexible(
                          flex: 1,
                          child: MarqueeWidget(
                            child: Text(lista[index].name, style: TextStyle(fontSize: 15, fontFamily: 'RobotoMono', color: ColorSets.colorText),),
                          ),
                        ),
                      ]
                  )
              ),
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(1),
            ),
          );
        }
    );
  }



  void confirmarCambios(BuildContext context, String password, String nombre, String pais,String fighter,String imagen) {
    if (nombre != "" && (nombre.length < 3 || nombre.length > 50)) {
      mostrarError(context,
          'Tu nuevo nombre de usuario debe contener entre 3 y 50 carácteres');
    }
    else if (password != "" && (password.length < 7 && password.length > 0)) {
      mostrarError(context, 'Tu constraseña debe ser de más de 7 carácteres');
    }
    else if (password != "" &&
        !password.contains(new RegExp(r'^[a-zA-Z]*[0-9][0-9a-zA-Z]*$'))) {
      mostrarError(context, 'Tu constraseña debe tener como mínimo 1 número y '
          'solo se aceptan minúsculas, mayúsculas y números ');
    }
    else {
      formularioContrasegna(context, password, nombre, pais,fighter,imagen);
      /*if(tmpFile!=null && base64Image!=null){
        startUploadPhoto(tmpFile , base64Image);
      }*/

    }
  }

  Widget showImage( size_width,size_height){
    return FutureBuilder<List<Foto>>(
      builder: (BuildContext context,AsyncSnapshot<List<Foto>> snapshot){


        if(snapshot.connectionState== ConnectionState.done && snapshot.data!=null && snapshot.data.isNotEmpty){
          print(snapshot.data);

          return Container(
              height: 200,
              width: 300,
              child: completeListHorizontalFotos ( snapshot.data,size_width,size_height));



        }
        else{
          return TuneITProgressIndicator();
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

  void formularioContrasegna (BuildContext context,String passprueba, String nombre,String pais,String id,String imagen) {
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

                     setState(() {
                       settingsUser(passprueba, nombre, pais,id,imagen);
                     });

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













