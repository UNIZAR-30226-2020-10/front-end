import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Foto.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/pais.dart';
import 'package:tuneit/widgets/textFields.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:email_validator/email_validator.dart';

import 'package:encrypt/encrypt.dart' as Encrypter;

import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  String pais = 'País de nacimiento';


  DateTime _date = DateTime.now();

  Future<File> la_imagen;
  String base64Image;
  File tmpFile;


  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      _date = order;
    });
  }

  Future<DateTime> getDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size_width = MediaQuery.of(context).size.width;
    final size_height= MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
          child: Container(
              width: size_width*0.8,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Image.asset('assets/LogoAppName.png'),
                    SizedBox(height: 30),
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0),
                          bottomLeft: const Radius.circular(25.0),
                          bottomRight: const Radius.circular(25.0),
                        ),
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF823b8e),
                            Color(0xFF5350a7),
                            Color(0xFF1c4c8b),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    textField(_controller1, false, 'Nombre de usuario',
                        Icons.person),
                    textField(_controller2, false, 'Correo electrónico',
                        Icons.mail_outline),
                    textField(_controller3, true, 'Contraseña',
                        Icons.lock_outline),
                    Column(
                      children: <Widget>[
                        widget_paises(countryDrop()),

                      ],

                    ),
                    Container(
                      color: ColorSets.colorWhite,
                      width: 400,
                      height: 1,
                    ),
                    RaisedButton(
                      color: Colors.transparent,
                      elevation: 0.0,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Icon(
                                  Icons.cake,
                                  color: ColorSets.colorGrey,
                                  size: 25,
                                ),
                              ),
                              Flexible(
                                child: SizedBox(width: 15),
                              ),
                              Flexible(
                                flex: 8,
                                child: Text(
                                  _date != null?_date.toString().substring(0,10) : DateTime.now().toString().substring(0,10),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white60,
                                      fontFamily: 'RobotoMono'
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                      onPressed: () {
                        callDatePicker();
                      },
                    ),
                    Container(
                      color: ColorSets.colorWhite,
                      width: 400,
                      height: 1,
                    ),
                    SizedBox(height: 30),
                    gradientButton(context, tryRegister, [], 'REGISTRARSE', 40, 150, 15),
                  ],
                ),
              )
          )
      ),
    );

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


  void tryRegister () {
    if (_controller1.text.toString().length < 1) {
      mostrarError('Tu nombre de usuario no puede estar vacío');
    }
    if (_controller1.text.toString().length < 3 || _controller1.text.toString().length > 50) {
      mostrarError('Tu nombre de usuario debe contener entre 3 y 50 carácteres');
    }
    else if (_controller2.text.toString().length < 1) {
      mostrarError('Tu correo electrónico no puede estar vacío');
    }
    else if(!EmailValidator.validate(_controller2.text.toString())){
      mostrarError('Tu correo electrónico debe ser un correo electrónico válido');
    }
    else if (_controller3.text.toString().length < 1) {
      mostrarError('Tu constraseña no puede estar vacía');
    }
    else if (_controller3.text.toString().length < 7){
      mostrarError('Tu constraseña debe ser de más de 7 carácteres');
    }
    else if(!_controller3.text.toString().contains(new RegExp(r'^[a-zA-Z]*[0-9][0-9a-zA-Z]*$'))){
    mostrarError('Tu constraseña debe tener como mínimo 1 número y '
    'solo se aceptan minúsculas, mayúsculas y números ');
    }
    else if (pais == 'País de nacimiento') {
      mostrarError('Es necesario que indiques tu país de nacimiento');
    }
    else {
      setState(() {
        final key = Encrypter.Key.fromUtf8('KarenSparckJonesProyectoSoftware');
        final iv = Encrypter.IV.fromLength(16);
        final encrypter = Encrypter.Encrypter(Encrypter.AES(key,mode: Encrypter.AESMode.ecb));
        final encrypted = encrypter.encrypt(_controller3.text, iv: iv);

        registerUser(
            _controller1.text, _controller2.text, encrypted.base64, parsingDate(_date.toString()), pais
        ).then((value) {
          if (value) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          }
          else {
            mostrarError('Ya existe un usuario registrado con tus datos');
          }
        });
      });
    }
  }

  void mostrarError(String description) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(description),
            actions: <Widget>[
              simpleButton(context, () {Navigator.of(context).pop();}, [], 'Volver')
            ],
          );
        }
    );
  }



  String parsingDate (String date) {
    List<String> splited = date.substring(0,10).split('-');
    String year = splited[0];
    String month = splited[1];
    String day = splited[2];

    return month + '/' + day + '/' + year;
  }

}

