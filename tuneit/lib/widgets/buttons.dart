import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/ColorSets.dart';

//------------------------------------------------------------------------------
// Widget del botón con degradado de colores sin comportamiento (NO USAR)
SizedBox gradientButton2 (String title) {
  return new SizedBox(
    height: 50,
    width: 230,
    child: Container(
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
              bottomLeft: const Radius.circular(25.0),
              bottomRight: const Radius.circular(25.0),
            ),
            gradient: LinearGradient(
              colors: <Color>[
                ColorSets.colorprimaryPink,
                Color(0x335350a7),
                Color(0x331c4c8b),
              ],
            ),
            border: Border.all(color: Colors.white70, width: 2)
        ),
        child: Center(
          child: Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'RobotoMono'
              )
          ),
        )
    ),
  );
}

// Widget del botón con degradado de colores funcional
//  func: función que describe el comportamiento onPressed del botón
//  arguments: lista con los argumentos de func (EN ORDEN)
// Ejemplo en pages/mainView.dart
Widget gradientButton (BuildContext context, Function func, List arguments, String text) {
  return RaisedButton(
      onPressed: () {
        Function.apply(func, arguments);
      },
      color: Colors.transparent,
      elevation: 0.0,
      child: gradientButton2(text)
  );
}

//------------------------------------------------------------------------------
// Widget del botón con color sólido funcional
//  func: función que describe el comportamiento onPressed del botón
//  arguments: lista con los argumentos de func (EN ORDEN)
// Ejemplo en pages/login.dart y pages/register.dart
Widget solidButton (BuildContext context, Function func, List arguments, String text) {
  return RaisedButton(
      onPressed: () {
        Function.apply(func, arguments);
      },
      color: Colors.transparent,
      elevation: 0.0,
      child: SizedBox(
        height: 50,
        width: 200.0,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                  bottomLeft: const Radius.circular(25.0),
                  bottomRight: const Radius.circular(25.0),
                ),
                color: Colors.white10,
                border: Border.all(color: Colors.white70, width: 2)
            ),
            child: Center(
              child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontFamily: 'RobotoMono'
                  )
              ),
            )
        ),
      )
  );
}

//------------------------------------------------------------------------------