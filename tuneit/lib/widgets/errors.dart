import 'package:encrypt/encrypt.dart' as Encrypter;
import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/pages/social/notificaciones.dart';
import 'package:tuneit/widgets/buttons.dart';
import 'package:tuneit/widgets/textFields.dart';

Widget NotDataFound(){
  return Center(
    child: ListView(
      children: <Widget>[
        Image(image: AssetImage(logoApp),
            fit: BoxFit.fill,
            width: 200,
            height: 200),
        Text(textoInutil_1)


      ],
    ),
  );
}

void mostrarError(BuildContext context,String description) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(

          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: AlertDialog(
              title: Text(error_mensaje),
              content: Text(description),
              actions: <Widget>[
                simpleButton(context, () {Navigator.of(context).pop();}, [], 'Volver')
              ],
            ),
        );
      }
  );
}

void operacionCancelada(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return GestureDetector(

        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },

        child: AlertDialog(
          title: new Text(exito_mensaje),
          content: new Text("Operacion cancelada"),

        ),
      );
    },
  );
}

void operacionExito(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          title: new Text(exito_mensaje),
          content: new Text("Operacion realizada de forma exitosa"),
          actions: <Widget>[
            simpleButton(context, () {Navigator.of(context).pop();}, [], 'Confirmar')
          ],

        );
    },
  );
}


void operacionExitoRecomendacion(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(exito_mensaje),
        content: new Text("Operacion realizada de forma exitosa"),
        actions: <Widget>[
          simpleButton(context, () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Notificaciones(),
              ),
            );
            }, [], 'Confirmar')
        ],

      );
    },
  );
}

void solicitudEnviada(BuildContext context,String amigo) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(exito_mensaje),
        content: new Text("Ha enviado una solicitud de amistad a " + amigo),
        actions: <Widget>[
          simpleButton(context, () {Navigator.of(context).pop();}, [], 'Confirmar')
        ],

      );
    },
  );
}

